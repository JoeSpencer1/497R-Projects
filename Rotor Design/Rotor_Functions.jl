#=---------------------------------------------------------------
11/3/2022
Rotor Functions v3 Rotor_Functions.jl
This code has a working mutable struct called RotorTest. I still
want to divide the header into smaller functions.
---------------------------------------------------------------=#

using CCBlade, FLOWMath, Xfoil, Plots, LaTeXStrings, DelimitedFiles, PointerArithmetic, Optim, Setfield

"""
   Analysis(rtest, v; D = 20, rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
Root function that calls other functions to analyze a rotor.
# Arguments
- rtest - The rotor sturct object that was created.
- v - The rotor's velocity, in m/s. Default 10 m/s.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- rfile - The file containint rotor information. Default "Rotor Design/Rotors/APC_10x7.txt".
- ffile - The file containint airfoil information. Default "Rotor Design/Rotors/naca4412_1e6.txt".
"""
function Analysis(rtest; v = 10, d = 20, rhub = 0.1, rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
    rread = readdlm(rfile) # Read rotor file.
    fread = ffile # Rename airfoil file.

    # Rotor geometry
    d = d * 0.0254 # Diameter inches to meters
    rtip = d/2 # Find tip radius from diameter.
    r = rread[:, 1] * rtip # Translate geometry from propellor percentatge to actual distance
    chord = rread[:, 2] * rtip * rtest.c # Translate chord to actual distance and multiply by chord factor.
    theta = rread[:, 3] * pi / 180 # Convert degrees to radians
    af = AlphaAF(fread) # Input airfoil information. 

    # This section adds twist to a propellor's twist distribution if applicable.
    for i in eachindex(theta)
        theta[i] += rtest.twist # Add twist to each segment.
    end

    sections = Section.(r, chord, theta, Ref(af)) # Divides the rotor into segments to analyze separately.

    omega = rtest.rpm * 2 * pi / 60 # Rotational Velocity in rad/s
    J = v / (d * rtest.rpm * 60 / (2 * pi)) # Create an advance ratio from the given information.
    rhub = rtip * rhub # Calculate hub length from tip length.
    rotor = Rotor(rhub, rtip, rtest.nb) # Create rotor.

    n = omega / (2 * pi) # Velocity in revolutions per second
    Vinf = J * d * n # Calculates freestream velocity
    op = simple_op.(Vinf, omega, r, rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
    eff, CT, CQ = nondim(T, Q, Vinf, omega, rho, rotor, "propeller") # Nondimensionalize output to make useable data
    P = rho * (rtest.rpm / (2 * pi)) ^ 3 * d ^ 5 * (CQ * 2 * pi) # Calculate P
    obj = eff * P / rtest.rpm # Use P to find the objective function.
    print(obj)
end

"""
    Rotortest
this struct creates a new rotor with updated properties.
# Arguments
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- nb - The number of blades in the rotor.
- rpm - The rotor's rotational velocity, in rpm.
"""
mutable struct Rotortest
    c::Float64
    twist::Float64
    nb::Float64
    rpm::Float64
end







#=
"""
Rotortest
This struct creates a new rotor with updated properties.
"""
mutable struct Rotortest
    #=
    c::Float64 
    nb::Int8
    phi::Float64
    rpm::Float64
    twist::Float64
    v::Float64
    D::Float64
    rho::Float64
    rgeom::Float64
    fgeom::Float64
    af::AlphaAF
    J::Float64
    eff::Float64
    CT::Float64
    CQ::Float64
    P::Float64
    obj::Float64
    =#
    c::Any
    nb::Any
    phi::Any
    rpm::Any
    twist::Any
    v::Any
    D::Any
    rho::Any
    rgeom::Any
    fgeom::Any
    af::Any
    J::Any
    eff::Any
    CT::Any
    CQ::Any
    P::Any
    obj::Any


    """
        setdata(rotor, c, nb, phi, rpm, twist, v, D, rho, rread, fread)
    This function establishes the rotor's initial paramiters.
    # Arguments
    - c - Rotor's camber length. As a factor of the given camber length from file.
    - nb - Rotor blade count. This is an integer value.
    - phi - Angle between freestream velocity and tangential velocity of rotor as it rotates.
    - rpm - Rotor's rotational velocity in revolutions per minute.
    - twist - Rotor's twist distribution.
    - v - Velocity.
    - D - Rotor diameter. Default 10
    - rho - Air density. Default 1.225
    - rgeom - The file with the geometry of the rotor. Default APC 10x7 "Rotor Design/Rotors/APC_10x7.txt"
    - fgeom - The file containing the airfoil geometry. Default NACA 4412, Reynolds number 1,000,000. "Rotor Design/Rotors/naca4412_1e6.dat"
    """
    function Rotortest(rotor, c, nb, phi, rpm, twist, v, D, rho, rread, fread)
        rotor.c = c
        rotor.nb = nb
        rotor.phi = phi
        rotor.ometa = rpm
        rotor.twist = twist
        rotor.v = v
        rotor.D = D
        rotor.rho = rho
        rotor.rgeom = rread
        rotor.fgeom = fread
        return rotor
    end
end

"""
    objective(D, c, nb, phi, rpm, twist; rgeom = "Rotor Design/Rotors/APC_10x7.txt", fgeom = "Rotor Design/Rotors/naca4412_1e6.dat")
Calculate and return the objective function based on each of the input variables. This can then be used in the optimize() function.
# Arguments
- c - Rotor's camber length. As a factor of the given camber length from file.
- nb - Rotor blade count. This is an integer value.
- phi - Angle between freestream velocity and tangential velocity of rotor as it rotates.
- rpm - Rotor's rotational velocity in revolutions per minute.
- twist - Rotor's twist distribution.
- v - Velocity.
- D - Rotor diameter. Default 10
- rho - Air density. Default 1.225
- rgeom - The file with the geometry of the rotor. Default APC 10x7 "Rotor Design/Rotors/APC_10x7.txt"
- fgeom - The file containing the airfoil geometry. Default NACA 4412, Reynolds number 1,000,000. "Rotor Design/Rotors/naca4412_1e6.dat"
"""
function objective(c, nb, phi, rpm, twist, v; D = 10, rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
    rread = readdlm(rfile)
    fread = readdlm(ffile)
    #rotor = Rotortest#(c = c, nb = nb, phi = phi, rpm = rpm, twist = twist, v = v, D = D, rho = rho, rgeom = rread, fgeom = fread)
    rotor = Rotortest(rotor, c, nb, phi, rpm, twist, v, D, rho, rread, fread)
    format(rotor)
    CDCPeff(rotor)
    rotor.P = rotor.rho * (rotor.rpm / (2 * pi)) ^ 3 * rotor.D ^ 5 * (rotor.CQ * 2 * pi)
    rotor.obj = rotor.eff * rotor.P / rotor.rpm
end




"""
    CDCPeff(rotor)
Find the coefficients of Thrust, Power, and Efficiency at different angles.
# Arguments
- rotor - The rotor created in the previous function. This function is called to find values for J, eff, CT, and CQ for the rotor.
"""
function CDCPeff(rotor::Rotortest)
    rgeom = Rotor(rotor.D / 2, rotor.D / 20, rotor.nb) # Create rotor
    local omega = rotor.rpm * 2 * pi / 60 # Rotational Velocity in rad/s
    rotor.J = rotor.v / (rotor.D * rotor.rpm * 60 / (2 * pi)) # Create an advance ratio from the given information.

    local Vinf = rotor.J * rotor.D * rotor.rpm # Calculates freestream velocity
    local op = simple_op.(rotor.v, omega, rotor.D / 2, rotor.rho) # Create operating point object to solve
    local outputs = solve.(Ref(rgeom), sections, op) # Solves op from previous line
    local T, Q = thrusttorque(rgeom, sections, outputs) # Integrate the area of the calucalted curve
    rotor.eff, rotor.CT, rotor.CQ = nondim(T, Q, Vinf, omega, rotor.rho, rgeom, "propeller") # Nondimensionalize output to make useable data
end

"""
    establish(rotor)
Find J, eff, CT, and CQ for a rotor.
# Arguments
- rotor - The rotor created in the first function. This function 
"""
function format(rotor::Rotortest)
    # The first section creates the propellor.
    rotor.D = rotor.D * 0.0254 # Diameter inches to meters

    # Rotor geometry
    r = rotor.rgeom[:, 1] * Rtip # Translate geometry from propellor percentatge to actual distance
    chord = rotor.rgeom[:, 2] .* Rtip .* rotor.c # Translate chord to actual distance and multiply by chord factor.
    theta = rotor.rgeom[:, 3] * pi / 180 # Convert degrees to radians
    # Find airfoil data at a variety of attack angles
    rotor.af = AlphaAF(rotor.fgeom)

    # This section adds twist to a propellor's twist distribution if applicable.
    for i in eachindex(theta)
        theta[i] += twist # Add twist to each segment.
    end

    # This section reads in experimental data and estimates results.
    sections = Section.(r, chord, theta, Ref(rotor.af)) # Define properties for individual sections
    CDCPeff(rpm, rgeom, sections, r, D; nJ = nJ, rho = rho, expr) # This is an internal function in this file.

    # Return these outputs.
    return J, eff, CT, CQ
end
=#