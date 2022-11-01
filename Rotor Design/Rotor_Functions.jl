#=---------------------------------------------------------------
10/31/2022
Rotor Functions v2 Rotor_Functions.jl
I have deleted unnecessary functions from this file and added an
objective function to optimize.

Format of this file:
    objective() - This function is called from main to create and test a new rotor. It runs the final test.
    Rotor - This struct stores all the attributes of the rotor.
    establish() - This function creates the rotor's geometry.
    CDCPeff() -  This function is called from objective() to find the CD, CP, and efficiency.
---------------------------------------------------------------=#

using CCBlade, FLOWMath, Xfoil, Plots, LaTeXStrings, DelimitedFiles, PointerArithmetic, Optim

"""
    objective(D, c, nb, phi, omega, twist; rgeom = "Rotor Design/Rotors/APC_10x7.txt", fgeom = "Rotor Design/Rotors/naca4412_1e6.dat")
Calculate and return the objective function based on each of the input variables. This can then be used in the optimize() function.
# Arguments
- D - Rotor diameter
- c - Rotor's camber length. As a factor of the given camber length from file.
- nb - Rotor blade count. This is an integer value.
- phi - Angle between freestream velocity and tangential velocity of rotor as it rotates.
- omega - Rotor's rotational velocity in revolutions per minute.
- twist - Rotor's twist distribution.
- v - Velocity.
- rho - Air density. Default 1.225
- rgeom - The file with the geometry of the rotor. Default APC 10x7 "Rotor Design/Rotors/APC_10x7.txt"
- fgeom - The file containing the airfoil geometry. Default NACA 4412, Reynolds number 1,000,000. "Rotor Design/Rotors/naca4412_1e6.dat"
"""
function objective(D, c, nb, phi, omega, twist, v; rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
    rread = readdlm(rfile)
    fread = readdlm(ffile)
    rotor = Rotortest(D = D, c = c, nb = nb, phi = phi, omega = omega, twist = twist, v = v, rho = rho, rgeom = rread, fgeom = fread)
    format(rotor)
    CDCPeff(rotor)
    rotor.P = rotor.rho * (rotor.omega / (2 * pi)) ^ 3 * rotor.D ^ 5 * (rotor.CQ * 2 * pi)
    rotor.obj = rotor.eff * rotor.P / rotor.omega
end

"""
    Rotortest
This struct creates a new rotor with updated properties.
"""
struct Rotortest
    D::Float64
    c::Float64
    nb::Int8
    phi::Float64
    omega::Float64
    twist::Float64
    v::Float64
    rho::Float64
    rgeom::Float64
    fgeom::Float64
    af::AlphaAF
    J::Float64
    eff::Float64
    CT::Float64
    CQ::Float64
    P::Float64
    omega::Float64
    obj::Float64
end







"""
    CDCPeff(rotor)
Find the coefficients of Thrust, Power, and Efficiency at different angles.
# Arguments
- rotor - The rotor created in the previous function. This function is called to find values for J, eff, CT, and CQ for the rotor.
"""
function CDCPeff(rotor::Rotortest)
    rgeom = Rotor(rotor.D / 2, rotor.D / 20, rotor.nb) # Create rotor
    local Omega = rotor.omega * 2 * pi / 60 # Rotational Velocity in rad/s
    rotor.J = rotor.v / (rotor.D * rotor.omega * 60 / (2 * pi)) # Create an advance ratio from the given information.

    local Vinf = rotor.J * rotor.D * rotor.omega # Calculates freestream velocity
    local op = simple_op.(rotor.v, Omega, rotor.D / 2, rotor.rho) # Create operating point object to solve
    local outputs = solve.(Ref(rgeom), sections, op) # Solves op from previous line
    local T, Q = thrusttorque(rgeom, sections, outputs) # Integrate the area of the calucalted curve
    rotor.eff, rotor.CT, rotor.CQ = nondim(T, Q, Vinf, Omega, rotor.rho, rgeom, "propeller") # Nondimensionalize output to make useable data
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