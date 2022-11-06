#=---------------------------------------------------------------
11/5/2022
Rotor Functions v5 Rotor_Functions.jl
I established the rotor and airfoil as global variables so I nondim
longer have to pass them into functions. This had become a
problem when they were passed into the optimizer function, since
they cannot really be optimized.
---------------------------------------------------------------=#

using Xfoil, CCBlade, SNOW, DelimitedFiles

global rread # Rotor Data
global fread # Airfoil Data
global M # Original moment coefficient
global T # Original torque

"""
   analysis(c, twist, v, rpm; nb = 3, d = 20, rho = 1.225, rfile = "Rotor Design/Rotors/APC_10x7.txt", ffile = "Rotor Design/Rotors/naca4412_1e6.dat")
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
# Outputs
- obj - A variable for the output of the objective function. The program wants to minimize this.
"""
function analysis(c, twist, v, rpm, nb, d, rhub, rho)
    rtest = Rotortest(c, twist, v, rpm) # Create a rotor.

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
    J = rtest.v / (d * rtest.rpm * 60 / (2 * pi)) # Create an advance ratio from the given information.
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
    moment
Calculate the moment experienced by a rotor.
# Arguments
# Outputs
- Mo - The total bending moment experienced by the rotor.
"""
function moment()
    Mo = 1
    return(Mo)
end

"""
    optimize(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225)
This function uses the SNOW code to find the optimal properties of the rotor.
# Arguments
- c - Chord length.
- twist - Twist, in degrees.
- v - Air velocity, in meters per second.
- rpm - Rotational velocity, in rpm.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
# Outputs
- xopt[1:4] - The optimal chord length, twist, velocity, and revolutions per minut for the rotor.
- xopt[1] - The optimal chord length.
- xopt[1] - The optimal twist.
- xopt[1] - The optimal velocity.
- xopt[1] - The optimal revolutions per minute.
"""
function optimize(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225)
    x0 = [c; twist; v; rpm; nb; d; rhub; rho]  # starting point
    ng = 2 # number of constraints
    lx = [0.1, -45, 0, 0.1, nb, d, rhub, rho]  # lower bounds on x
    ux = [100.0, 45, 300, 10000, nb, d, rhub, rho]  # upper bounds on x
    lg = -Inf * ones(ng)  # lower bounds on g
    ug = [1.1, 1.1] # upper bounds on g
    options = Options(solver=IPOPT())  # choosing IPOPT solver

    # Optimize function with constraints defined above
    xopt, fopt, info = minimize(simple!, x0, ng, lx, ux, lg, ug, options)

    println("xstar = ", xopt[1:4]) # Print the found values (Only the variable ones). 
    println("fstar = ", fopt)
    println("info = ", info)

    return(xopt[1:4])
end

"""
    Rotortest
this struct creates a new rotor with updated properties.
# Members
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- v - The air velocity, in m/s.
- rpm - The rotor's rotational velocity, in rpm.
"""
mutable struct Rotortest
    c::Float64 # Chord length
    twist::Float64 # Twist of entire rotor blade
    v::Float64 # Wind velocity
    rpm::Float64 # Rotational velocity
end

"""
    simple!(g, x)
This function is called from the optimize() function. It performs the rotor analysis over and over.
# Arguments
- g - Constraint functions used to restrain the moment coefficient and the torque coefficient.
- g[1] - Constrains the bending moment coefficient below 110% original value. 
- g[1] - Constrains the torque coefficient below 110% original value. 
- x - This array contains the data contained in the Rotortest struct, in order.
- x[1] - Chord length.
- x[2] - Twist, in degrees.
- x[3] - Air velocity, in meters per second.
- x[4] - Rotational velocity, in rpm.
- x[5] - The number of blades in the rotor. Default 3.
- x[6] - The rotor's diameter. Default 20 feet.
- x[7] - Ratio of the hub length to tip lentgh. Defulat 0.1.
- x[8] - The air density. Default 1.225.
# Outputs
- g - Constraint functions used to restrain the moment coefficient and the torque coefficient.
- g[1] - Constrains the bending moment coefficient below 110% original value. 
- g[1] - Constrains the torque coefficient below 110% original value. 
- x - This array contains the data contained in the Rotortest struct, in order.
- x[1] - Chord length.
- x[2] - Twist, in degrees.
- x[3] - Air velocity, in meters per second.
- x[4] - Rotational velocity, in rpm.
- x[5] - The number of blades in the rotor. Default 3.
- x[6] - The rotor's diameter. Default 20 feet.
- x[7] - Ratio of the hub length to tip lentgh. Defulat 0.1.
- x[8] - The air density. Default 1.225.
"""
function simple!(g, x)
    # objective
    f = analysis(x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8]) # Calculate objective function

    # constraints
    g[1] = 1 # Bending moment coefficient constraint
    g[2] = 1 # Torque coefficient constraint

    return f
end

"""
    torque
Calculate the torque experienced by a rotor.
# Arguments
# Outputs
- Tq - The torque experienced by the rotor.
"""
function torque()
    Tq = 1
    return(Tq)
end