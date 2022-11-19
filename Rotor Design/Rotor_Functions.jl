#=---------------------------------------------------------------
11/19/2022
Rotor Functions v11 Rotor_Functions.jl
This version of the code has an updated program that can usually
optimize a rotor at several advance ratios, as long as it 
doesn't get stuck at a plateau.
---------------------------------------------------------------=#

using Xfoil, CCBlade, SNOW, DelimitedFiles, FLOWMath, QuadGK, Plots

global rread # Rotor Data
global fread # Airfoil Data
global Q0 # Original torque
global Mn # Normal moment coefficien
global Mt # Tangential moment coefficient

"""
    Rotortest
this struct creates a new rotor with updated properties.
# Members
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- rpm - The rotor's rotational velocity, in rpm.
- nb - The rotor's blade count
- d - The outer diameter
- rhub - The hub radius as a fraction of the outer radius
- rho - The fluid density
- v - Freestream velocity.
"""
mutable struct Rotortest
    c::Float64 # Chord length
    twist::Float64 # Twist of entire rotor blade
    rpm::Float64 # Rotational velocity
    nb::Float64 # Rotor blade count. This should be an int32, but my code struggled with that.
    d::Float64 # Rotor outer diameter
    rhub::Float64 # Rotor hub length
    rho::Float64 # Air density
    v::Float64 # Freestream velocity
end

"""
   analysis(c, twist; rpm = 500, nb = 3, d = 20, rho = 1.225, v = 45)
Root function that calls other functions to analyze a rotor.
# Arguments
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- rpm - The rotor's rotational velocity, in rpm. Default 500.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- v - Freestream velocity. Default 20 m/s.
# Outputs
- obj - A variable for the output of the objective function. The program wants to minimize this.
"""
function analysis(c, twist, rpm, nb, d, rhub, rho, v)
    rtest = Rotortest(c, twist, rpm, nb, d, rhub, rho, v) # Create a rotor.

    # Rotor geometry
    rtest.d = rtest.d * 0.0254 # Diameter inches to meters
    rtip = rtest.d / 2 # Find tip radius from diameter.
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
    op = simple_op.(v, omega, r, rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
    eff, CT, _ = nondim(T, Q, v, omega, rho, rotor, "propeller") # Nondimensionalize output to make useable data

    obj = 1 / (eff) # Maximize thrust, velocity, and efficiency.

    # Output resulting objective function.
    return(obj)
end

"""
    coefficients(ropt; Jmax = 0.6, nJ = 10)
This function outputs data for graphing of coefficients against advance ratios.
# Arguments
- ropt - Rotor object created previously
- Jmax - Maximum advance ratio. Default 0.6.
- nJ - Quantity of advance ratios tested. Default 10.
# Outputs
- J - Vector of advance ratios simulated.
- eff - Vector of effectivenesses
- CT - The thrust coefficient at each J
- CQ - The torque coefficient at each J
"""
function coefficients(ropt; Jmax = 0.6, nJ = 20)

    # This first section finds the torque, Q0.

    rtest = Rotortest(ropt.c, ropt.twist, ropt.rpm, ropt.nb, ropt.d, ropt.rhub, ropt.rho, ropt.v) # Create a rotor.

    # Rotor geometry
    rtest.d = rtest.d * 0.0254 # Diameter inches to meters
    rtip = rtest.d / 2 # Find tip radius from diameter.
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
    rtest.rhub = rtip * rtest.rhub # Calculate hub length from tip length.
    rotor = Rotor(rtest.rhub, rtip, rtest.nb) # Create rotor.

    # Find efficiency and power of the rotor at this rpm.

    J = rtest.v / (rtest.d * rtest.rpm * 60 / (2 * pi)) # Create an advance ratio from the given information.
    n = omega / (2 * pi) # Velocity in revolutions per second
    Vinf = J * rtest.d * n # Calculates freestream velocity
    op = simple_op.(Vinf, omega, r, rtest.rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q0 = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve

    eff = zeros(nJ) # Zeros vector for efficiency
    CT = zeros(nJ) # Zeros vector for CT
    CQ = zeros(nJ) # Zeros vector for CQ
    Omega = rtest.rpm * 2 * pi / 60 # Rotational Velocity in rad/s
    J = range(0, Jmax, length = nJ)  # advance ratio
    n = Omega / (2 * pi) # Convert rad/s to rev/s
    for i = 1:nJ
        local Vinf = J[i] * rtest.d * n # Calculates freestream velocity
        local op = simple_op.(Vinf, Omega, r, rtest.rho) # Create operating point object to solve
        outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
        T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
        eff[i], CT[i], CQ[i] = nondim(T, Q, Vinf, Omega, rtest.rho, rotor, "propeller") # Nondimensionalize output to make useable data
    end

    return J, eff, CT, CQ # Return variables that will become global.
end

"""
    initialize(c, twist; rpm, nb = 3, d = 20, rhub = 0.1, rho = 1.225, fac = 1.1, Jmax = 0.6, nJ = 20, v = 45)
This function establishes the initial constant values for the rotor's moment and torque. Calculate the coefficients of thrust and torque and the effectiveness.
# Arguments
- c - Chord length.
- twist - Twist, in degrees.
- rpm - Rotational velocity, in rpm. Default 500.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- fac - The factor used for defining limits. Default 1.1
- v - The rotor's initial velocity. Used to calculate the initial advance ratio. Default 20 m/s
# Outputs
- Q0 - The torque multiplied by n.
- Mn - The moment in the normal direction
- Mt - Moment in the tangential direction
"""
function initialize(c, twist; rpm = 500, nb = 3, d = 20, rhub = 0.1, rho = 1.225, fac = 1.1, v = 45)

    # This first section finds the torque, Q0.

    rtest = Rotortest(c, twist, rpm, nb, d, rhub, rho, v) # Create a rotor.

    # Rotor geometry
    rtest.d = rtest.d * 0.0254 # Diameter inches to meters
    rtip = rtest.d / 2 # Find tip radius from diameter.
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
    rtest.rhub = rtip * rtest.rhub # Calculate hub length from tip length.
    rotor = Rotor(rtest.rhub, rtip, rtest.nb) # Create rotor.

    # Find efficiency and power of the rotor at this rpm.

    J = rtest.v / (rtest.d * rtest.rpm * 60 / (2 * pi)) # Create an advance ratio from the given information.
    n = omega / (2 * pi) # Velocity in revolutions per second
    Vinf = J * rtest.d * n # Calculates freestream velocity
    op = simple_op.(Vinf, omega, r, rtest.rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q0 = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve

    # Next, find the normal moment Mn
    N = outputs.Np # Normal stresses on wing
    Nfit = Akima(r, N) # Integrate normal forces
    momn(r) = r * Nfit(4) # Find normal stresses
    Mn, _ = quadgk(momn, rtest.rhub, rtip) # Integrate normal stresses

    # Next, find the normal moment Mn
    T = outputs.Tp # Tangental stresses on wing
    Tfit = Akima(r, T) # Integrate tangential forces
    momt(r) = r * Tfit(4) # Find tangential stress
    Mt, _ = quadgk(momt, rtest.rhub, rtip) # Integrate tangential stress.

    Q0 = Q0 * fac # multiply by factor
    Mn = Mn * fac # multiply by factor
    Mt = Mt * fac # multiply by factor

    return Q0, Mn, Mt # Return variables that will become global.
end

"""
   multi(c, twist; rpm = 500, nb = 3, d = 20, rho = 1.225, v = 45, np = 5, rp = 0.8, lp = 0.1)
Root function that calls other functions to analyze a rotor.
# Arguments
- c - Rotor's chord length, as a factor of the given lengths in the file.
- twist - Rotor's twist. Twist is uniform across entire rotor.
- rpm - The rotor's rotational velocity, in rpm. Default 500.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- v - Freestream velocity. Default 20 m/s.
- np - The number of advance ratios that will be optimized. Default 5.
- rp - The range of the advance ratios. Default 0.8.
- lp - The lowest advance ratio that will be checked. Default 0.1.
# Outputs
- obj - A variable for the output of the objective function. The program wants to minimize this.
"""
function multi(c, twist, rpm, nb, d, rhub, rho, v, np, rp, lp)
    obj = 0 # Set objective to zero

    for i = 1:np
        J = lp + (i - 1.0) * rp / (np - 1.0) # Find the advance ratio
        rpm = v / (J * d / 60) # Find new rpm for this advance ratio

        rtest = Rotortest(c, twist, rpm, nb, d, rhub, rho, v) # Create a rotor.

        # Rotor geometry
        rtest.d = rtest.d * 0.0254 # Diameter inches to meters
        rtip = rtest.d / 2 # Find tip radius from diameter.
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
        J = v / (rtest.d * rtest.rpm * 60) # Create an advance ratio from the given information.
        # Find efficiency and power of the rotor at this rpm.
        n = omega / (2 * pi) # Velocity in revolutions per second
        Vinf = J * d * n # Calculates freestream velocity
        op = simple_op.(Vinf, omega, r, rho) # Create operating point object to solve
        outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
        T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
        eff, CT, _ = nondim(T, Q, Vinf, omega, rho, rotor, "propeller") # Nondimensionalize output to make useable data

        obj += (eff) # Maximize thrust, velocity, and efficiency.
    end

    # Output resulting objective function.
    return(100 / obj)
end

"""
    multiopt(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225, np = 5, rp = 0.5, lp = 0.2)
This function uses the SNOW code to find the optimal properties of the rotor.
# Arguments
- c - Chord length.
- twist - Twist, in degrees.
- rpm - Rotational velocity, in rpm. Default 500
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- v - Freestream velocity. Default 20 m/s.
- uc - Upper camber limit. Default 100.0
- utwist - Upper twist angle limit. Default 90˚ 
- type - The analysis that will be performed. Default 1.
- np - The number of advance ratios that will be optimized. Default 5.
- rp - The range of the advance ratios. Default 0.5.
- lp - The lowest advance ratio that will be checked. Default 0.2.
# Outputs
- ropt - Rotor object with optimal properties.
"""
function multiopt(c, twist; rpm = 500, nb = 3, d = 20, rhub = 0.1, rho = 1.225, v = 45 * pi / 180, uc = 2.0, utwist = 90, np = 5, rp = 0.5, lp = 0.2)
    # nb = trunc(Int32, nb)
    x0 = [c; twist; rpm; nb; d; rhub; rho; v; np; rp; lp] # starting point
    ng = 3 # number of constraints
    lx = [(1 / uc), (0 - utwist), rpm, nb, d, rhub, rho, v, np, rp, lp]  # lower bounds on x
    ux = [uc, utwist, rpm, nb, d, rhub, rho, v, np, rp, lp] # upper bounds on x
    lg = zeros(ng)  # lower bounds on g
    ug = [Q0, Mn, Mt] # upper bounds on g
    options = Options(solver=IPOPT())  # choosing IPOPT solver

    # Optimize function with constraints defined above
    xopt, fopt, info = minimize(simple1!, x0, ng, lx, ux, lg, ug, options)

    println("xstar = ", xopt[1:4]) # Print the found values (Only the variable ones). 
    println("fstar = ", fopt)
    println("info = ", info)

    ropt = Rotortest(xopt[1], xopt[2], xopt[3], xopt[4], xopt[5], xopt[6], xopt[7], xopt[8])
    return(ropt)
end

"""
    objective(c, twist, rpm, nb, d, rhub, rho, v = 45)
This function is similar to initialize(). It returns the the torque, normal moment, and tangential moment to ensure the rotor is within its limits.
# Arguments
- c - Chord length.
- twist - Twist, in degrees.
- rpm - Rotational velocity, in rpm. Default 500.
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- v - The freestream velocity. Default 45.
# Outputs
- Q0 - The torque multiplied by n.
- Mn - The moment in the normal direction
- Mt - Moment in the tangential direction
"""
function objective(c, twist, rpm, nb, d, rhub, rho; v = 45)

    # This first section finds the torque, Q0.

    rtest = Rotortest(c, twist, rpm, nb, d, rhub, rho, v) # Create a rotor.

    # Rotor geometry
    rtest.d = rtest.d * 0.0254 # Diameter inches to meters
    rtip = rtest.d / 2 # Find tip radius from diameter.
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
    rtest.rhub = rtip * rtest.rhub # Calculate hub length from tip length.
    rotor = Rotor(rtest.rhub, rtip, rtest.nb) # Create rotor.
    
    # Find efficiency and power of the rotor at this rpm.

    J = v / (rtest.d * rtest.rpm * 60) # Create an advance ratio from the given information.
    n = omega / (2 * pi) # Velocity in revolutions per second
    Vinf = J * d * n # Calculates freestream velocity
    op = simple_op.(Vinf, omega, r, rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q0 = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve

    # Next, find the normal moment Mn
    N = outputs.Np # Normal stresses on wing
    Nfit = Akima(r, N) # Integrate normal forces
    momn(r) = r * Nfit(4) # Find normal stresses
    Mn, _ = quadgk(momn, rtest.rhub, rtip) # Integrate normal stresses

    # Next, find the normal moment Mn
    T = outputs.Tp # Tangental stresses on wing
    Tfit = Akima(r, T) # Integrate tangential forces
    momt(r) = r * Tfit(4) # Find tangential stress
    Mt, _ = quadgk(momt, rtest.rhub, rtip) # Integrate tangential stress.

    # Do not multiply by any safety factor.
    return Q0, Mn, Mt
end

"""
    optimize(c, twist, v, rpm; nb = 3, d = 20, rhub = 0.1, rho = 1.225)
This function uses the SNOW code to find the optimal properties of the rotor.
# Arguments
- c - Chord length.
- twist - Twist, in degrees.
- rpm - Rotational velocity, in rpm. Default 500
- nb - The number of blades in the rotor. Default 3.
- d - The rotor's diameter. Default 20 feet.
- rhub - Ratio of the hub length to tip lentgh. Defulat 0.1.
- rho - The air density. Default 1.225.
- v - Freestream velocity. Default 20 m/s.
- uc - Upper camber limit. Default 100.0
- utwist - Upper twist angle limit. Default 90˚ 
- type - The analysis that will be performed. Default 1.
# Outputs
- ropt - Rotor object with optimal properties.
"""
function optimize(c, twist; rpm = 500, nb = 3, d = 20, rhub = 0.1, rho = 1.225, v = 45 * pi / 180, uc = 2.0, utwist = 90)
    # nb = trunc(Int32, nb)
    x0 = [c; twist; rpm; nb; d; rhub; rho; v] # starting point
    ng = 3 # number of constraints
    lx = [(1 / uc), (0 - utwist), rpm, nb, d, rhub, rho, v]  # lower bounds on x
    ux = [uc, utwist, rpm, nb, d, rhub, rho, v] # upper bounds on x
    lg = zeros(ng)  # lower bounds on g
    ug = [Q0, Mn, Mt] # upper bounds on g
    options = Options(solver=IPOPT())  # choosing IPOPT solver

    # Optimize function with constraints defined above
    xopt, fopt, info = minimize(simple!, x0, ng, lx, ux, lg, ug, options)

    println("xstar = ", xopt[1:4]) # Print the found values (Only the variable ones). 
    println("fstar = ", fopt)
    println("info = ", info)

    ropt = Rotortest(xopt[1], xopt[2], xopt[3], xopt[4], xopt[5], xopt[6], xopt[7], xopt[8])
    return(ropt)
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
- x[3] - Rotational velocity, in rpm. Default 500.
- x[4] - The number of blades in the rotor. Default 3.
- x[5] - The rotor's diameter. Default 20 feet.
- x[6] - Ratio of the hub length to tip lentgh. Defulat 0.1.
- x[7] - The air density. Default 1.225.
- x[8] - The freestream velocity. Default 20 m/s
# Outputs
- g - Constraint functions used to restrain the moment coefficient and the torque coefficient.
- g[1] - Constrains the bending moment coefficient below 110% original value. 
- g[1] - Constrains the torque coefficient below 110% original value. 
- x - This array contains the data contained in the Rotortest struct, in order.
- x[1] - Chord length.
- x[2] - Twist, in degrees.
- x[3] - Rotational velocity, in rpm.
- x[4] - The number of blades in the rotor. Default 3.
- x[5] - The rotor's diameter. Default 20 feet.
- x[6] - Ratio of the hub length to tip lentgh. Defulat 0.1.
- x[7] - The air density. Default 1.225.
- x[8] - The freestream velocity. Default 20 m/s
"""
function simple!(g, x)
    # objective
    f = analysis(x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8]) # Calculate objective function

    # constraints
    # Calculate these constants the wame 
    g[1], g[2], g[3] = objective(x[1], x[2], x[3], x[4], x[5], x[6], x[7], v = x[8])

    return f
end

"""
    simple1!(g, x)
This function is called from the optimize() function. It performs the rotor analysis over and over.
# Arguments
- g - Constraint functions used to restrain the moment coefficient and the torque coefficient.
- g[1] - Constrains the bending moment coefficient below 110% original value. 
- g[1] - Constrains the torque coefficient below 110% original value. 
- x - This array contains the data contained in the Rotortest struct, in order.
- x[1] - Chord length.
- x[2] - Twist, in degrees.
- x[3] - Rotational velocity, in rpm. Default 500.
- x[4] - The number of blades in the rotor. Default 3.
- x[5] - The rotor's diameter. Default 20 feet.
- x[6] - Ratio of the hub length to tip lentgh. Defulat 0.1.
- x[7] - The air density. Default 1.225.
- x[8] - The freestream velocity. Default 20 m/s
# Outputs
- g - Constraint functions used to restrain the moment coefficient and the torque coefficient.
- g[1] - Constrains the bending moment coefficient below 110% original value. 
- g[1] - Constrains the torque coefficient below 110% original value. 
- x - This array contains the data contained in the Rotortest struct, in order.
- x[1] - Chord length.
- x[2] - Twist, in degrees.
- x[3] - Rotational velocity, in rpm.
- x[4] - The number of blades in the rotor. Default 3.
- x[5] - The rotor's diameter. Default 20 feet.
- x[6] - Ratio of the hub length to tip lentgh. Defulat 0.1.
- x[7] - The air density. Default 1.225.
- x[8] - The freestream velocity. Default 20 m/s
"""
function simple1!(g, x)
    # objective
    f = multi(x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9], x[10], x[11]) # Calculate objective function

    # constraints
    # Calculate these constants the wame 
    g[1], g[2], g[3] = objective(x[1], x[2], x[3], x[4], x[5], x[6], x[7], v = x[8])

    return f
end