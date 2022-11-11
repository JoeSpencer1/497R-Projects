#=---------------------------------------------------------------
11/10/2022
Rotor Functions v7 Rotor_Functions.jl
I updated the functions to more reasonable objectives after my
meeting with Adam.
---------------------------------------------------------------=#

using Xfoil, CCBlade, SNOW, DelimitedFiles, FLOWMath, QuadGK, Plots

global rread # Rotor Data
global fread # Airfoil Data
global Q0 # Original torque
global Mn # Normal moment coefficien
global Mt # Tangential moment coefficient

"""
   analysis(c, twist, v, rpm; nb = 3, d = 20, rho = 1.225)
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
- type - The optimizer function that will be used. Default 1.
# Outputs
- obj - A variable for the output of the objective function. The program wants to minimize this.
"""
function analysis(c, twist, v, rpm, nb, d, rhub, rho, type)
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
    CP = 2 * pi * CQ # Power coefficient from torque coefficient

    obj = 0 # Initialize obj
    if type == 1 # Second analysis performed, which found η * CT * v
        obj = 100 / (CT * v * eff) # Maximize thrust, velocity, and efficiency.
    end
    if type == 2 # Third analysis performed. Finds CT / CP
        obj = v / (CP * CT) # Maximizes thrust while minimizing power
    end
    if type == 3 # First analysis performed, which found η / P rpm
        obj = rtest.rpm * P / (100000 * eff) # Use P to find the objective function.
    end

    # Output resulting objective function.
    return(obj)
end

"""
    initialize(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225, fac = 1.1)
This function establishes the initial constant values for the rotor's moment and torque.
# Arguments
- c - Chord length.
- twist - Twist, in degrees.
- v - Air velocity, in meters per second.
- rpm - Rotational velocity, in rpm.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- n - The factor used for defining limits.
# Outputs
- Q0 - The torque multiplied by n.
- Mn - The moment in the normal direction
- Mt - Moment in the tangential direction
"""
function initialize(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225, fac = 1.1)

    # This first section finds the torque, Q0.

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
    T, Q0 = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve

    # Next, find the normal moment Mn
    N = outputs.Np # Normal stresses on wing
    Nfit = Akima(r, N) # Integrate normal forces
    momn(r) = r * Nfit(4) # Find normal stresses
    Mn, _ = quadgk(momn, rhub, rtip) # Integrate normal stresses

    # Next, find the normal moment Mn
    T = outputs.Tp # Tangental stresses on wing
    Tfit = Akima(r, T) # Integrate tangential forces
    momt(r) = r * Tfit(4) # 
    Mt, _ = quadgk(momt, rhub, rtip)

    Q0 = Q0 * fac # multiply by factor
    Mn = Mn * fac # multiply by factor
    Mt = Mt * fac # multiply by factor

    return Q0, Mn, Mt # Return variables that will become global.
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
- uc - Upper camber limit. Default 100.0
- utwist - Upper twist angle limit. Default 45˚ 
- uv - Upper velocity limit. Default 300 m/s 
- urpm - Upper rpm limit. Default 1000
- type - The analysis that will be performed. Default 1.
# Outputs
- xopt[1:4] - The optimal chord length, twist, velocity, and revolutions per minut for the rotor.
- xopt[1] - The optimal chord length.
- xopt[1] - The optimal twist.
- xopt[1] - The optimal velocity.
- xopt[1] - The optimal revolutions per minute.
"""
function optimize(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225, uc = 100.0, utwist = 45, uv = 300, urpm = 1000, type = 1)
    x0 = [c; twist; v; rpm; nb; d; rhub; rho; type] # starting point
    ng = 3 # number of constraints
    lx = [0.1, (0 - utwist), 0, 0.1, nb, d, rhub, rho, type]  # lower bounds on x
    ux = [uc, utwist, uv, urpm, nb, d, rhub, rho, type] # upper bounds on x
    lg = zeros(ng)  # lower bounds on g
    ug = [Q0, Mn, Mt] # upper bounds on g
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
- x[9] - The type of analysis that will be performed. Default 1.
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
- x[9] - The type of analysis that will be performed. Default 0.
"""
function simple!(g, x)
    # objective
    f = analysis(x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9]) # Calculate objective function

    # constraints
    # Calculate these constants the wame 
    g[1], g[2], g[3] = initialize(x[1], x[2], x[3], x[4], nb = x[5], d = x[6], rhub = x[7], rho = x[8])

    return f
end