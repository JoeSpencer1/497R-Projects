#=---------------------------------------------------------------
11/3/2022
Rotor Functions v3 Rotor_Functions.jl
This code has a working mutable struct called RotorTest. I still
want to divide the header into smaller functions.
---------------------------------------------------------------=#

using CCBlade, FLOWMath, Xfoil, Plots, LaTeXStrings, DelimitedFiles, PointerArithmetic, SNOW, Setfield

"""
   Analysis(c, twist, v, rpm; nb = 3, d = 20, rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
Root function that calls other functions to analyze a rotor.
# Arguments
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- v - The rotor's velocity, in m/s.
- rpm - The rotor's rotational velocity, in rpm.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- rfile - The file containint rotor information. Default "Rotor Design/Rotors/APC_10x7.txt".
- ffile - The file containint airfoil information. Default "Rotor Design/Rotors/naca4412_1e6.txt".
"""
function Analysis(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
    rtest = Rotortest(c, twist, v, rpm)
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

    # Create rotor.
    sections = Section.(r, chord, theta, Ref(af)) # Divides the rotor into segments to analyze separately.
    omega = rtest.rpm * 2 * pi / 60 # Rotational Velocity in rad/s
    rhub = rtip * rhub # Calculate hub length from tip length.
    rotor = Rotor(rhub, rtip, nb) # Create rotor.

    # Find efficiency and power of the rotor at this rpm.
    J = rotor.v / (d * rtest.rpm * 60 / (2 * pi)) # Create an advance ratio from the given information.
    n = omega / (2 * pi) # Velocity in revolutions per second
    Vinf = J * d * n # Calculates freestream velocity
    op = simple_op.(Vinf, omega, r, rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
    eff, CT, CQ = nondim(T, Q, Vinf, omega, rho, rotor, "propeller") # Nondimensionalize output to make useable data
    P = rho * (rtest.rpm / (2 * pi)) ^ 3 * d ^ 5 * (CQ * 2 * pi) # Calculate P
    obj = rtest.rpm / (eff * P) # Use P to find the objective function.

    # Output resulting objective function.
    return(obj)
end

"""
    Rotortest
this struct creates a new rotor with updated properties.
# Arguments
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- v - The rotor's velocity, in m/s.
- rpm - The rotor's rotational velocity, in rpm.
"""
mutable struct Rotortest
    c::Float64
    twist::Float64
    v::Float64
    rpm::Float64
end