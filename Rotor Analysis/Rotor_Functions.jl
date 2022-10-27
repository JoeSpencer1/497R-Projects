#=---------------------------------------------------------------
10/17/2022
Rotor Functions v6 Rotor_Functions.jl
This is the header file that I have finished for the initial
submission.
---------------------------------------------------------------=#

using CCBlade, FLOWMath, Xfoil, Plots, LaTeXStrings, DelimitedFiles, PointerArithmetic

"""
    create(; mpth = 4412, n = 14)
Creates a NACA airfoil from its 4-digit number.
# Arguments
- mpth - The airfoil's NACA number. Default 4412.
- n - The number of points that will be modeled on each side of the airfoil. Default 14.
# outputs
- The x and y coordinates at different points along the propellor surface.
"""
function create(; mpth = 4412, n = 14)
    nd = n * 1.0 # Converts n to a decimal.
    n2 = n * 2 + 1 # Gives total array length.
    x = Array{Float64}(undef, n2, 1) # x-coordinate array
    y = Array{Float64}(undef, n2, 1) # y-coordinate array
    for i in 1:n2  
        # Populates x array.
        if i < (n + 2) # Beginning items start at 1 and go down to 0
            x[i] = 1 - (i - 1) / nd
        end
        if i > (n + 1) # Entries in second half of list go back to 1
            x[i] = (i - n - 1) / nd
        end
    end
    th = mod(mpth, 100) / 100 # Last 2 digits describe thickness
    p = (mod(mpth, 1000) - th * 100) / 1000 # 2nd digit is p
    m = (mpth - p * 1000 - th* 100) / 100000 # 1st digit is m
    for i in 1:n2
        if i < n + 1 # This general equation is for top of fin
            y[i] = 5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if i > n # Same general equation, for bottom of fin
            y[i] = -5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if x[i] <= p # Fin adjustment at front
            y[i] += (2 * p * x[i] - x[i] ^ 2) * m / p ^ 2
        end
        if x[i] > p # Fin adjustmant at rear
            y[i] += ((1 - 2 * p) + 2 * p * x[i] - x[i] ^ 2) * m / (1 - p) ^ 2
        end
    end
    return x, y
end

"""
    coeff(x, y; increment = 1, iterations = 100, re = 1e6, min = -15, max = 15)
Find the coefficients of an airfoil. Like create(), is borrowed from the Airfoil Analysis project.
# Arguments
- x - Airfoil's x-coordinates.
- y - Airfoil's y-coordinates.
- increment - Distance between angles of attack. Default 1.
- iterations - Number of times Xfoil alpha_sweep code needs to try before failing to converge. Default 100.
- re - Reynolds number used in alpha_sweep function. Default 1e6
- min - minimum angle of attack. Default -15˚.
- max - maximum angle of attack. Default 15˚.
# outputs
- Angles of attack alpha
- Lift coefficient c_l at each alpha
- Drag coefficient c_d at each alpha
- Polar drag coeffient c_dp at each alpha
- Moment coefficient c_m at each alpha
- A vector called converged stating whether a converted solution was found at each alpha
"""
function coeff(x, y; increment = 1, iterations = 100, re = 1e6, min = -15, max = 15)
    alpha = min:increment:max # Establish values of alhpha over range
    # This next function finds various coefficients for the airfoil.
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)
    return alpha, c_l, c_d, c_dp, c_m, converged
end

"""
   rads(rpm)
Converts rpm to rad/s by a known factor.
# Arguments
- rpm - Rotational velocity in revolutions per minute
# Outputs
- rpm value multiplied by a 2pi/60 factor to convert to rad/s
"""
function rads(rpm)
    return rpm * 2 * pi / 60 # This allows you to call a function to convert.
end

"""
    rad(deg)
Converts degress to radians.
# Arguments
- deg - Rotational distance in degrees.
# Outputs
- degree value multiplied by pi/180 for conversion to radians.
"""
function rad(deg)
    return deg * pi / 180 # Simple multiplication for radians to degrees
end

"""
    rev(rad)
Convers radians to revolutions
# Arguments
- rad - The quantity of radians revolved.
# Outputs
- rad value divided by 2pi to obtain the same value in revolutions
"""
function rev(rad)
    return rad / (2 * pi) # Convert radians to revolutions.
end

"""
    TransonicDrag
This struct was copied from Guided_Example.jl. It finds the drag based on a mach number.
"""
struct TransonicDrag <: MachCorrection
    Mcc  # crest critical Mach number
end

"""
    Convert(geom, rtip)
Mltiplies a proportion by the propellor tip length.
# Arguments
- geom - Airfoil geometry on a unit scale, to be multiplied by rtip.
- rtip - Airfoil tip radius multiplication factor.
# Outputs
- product of the tip radius and the geometry in fractions of the tip radius. This function converts the geometry to its actual value.
"""
function Convert(geom, rtip)
    return geom[:] * rtip # This changes the geometry to terms of rtip instead of 1.
end

"""
    Loadexp(filename)
Loads experimental data from a file.
# Arguments
- filename - Address of experimental data file to be loaded.
# Outputs
- Jexp - Experimental nondimensional angles.
- CTexp - Experimental twist coefficients.
- CPexp - Experimental power coefficients. Note that the torque coefficient CQexp has to be derived from this.
- etaexp - Experimental efficiencies.
"""
function Loadexp(filename) # Function designed to read 4-column experimental data.
    exp = readdlm(filename, '\t', Float64, '\n') # File is divided by tabs and endlines.
    Jexp = exp[:, 1] # J in first column
    CTexp = exp[:, 2] # CT in second column
    CPexp = exp[:, 3] # CP in third column
    etaexp = exp[:, 4] # eta in foruth column.
    return Jexp, CTexp, CPexp, etaexp
end

"""
    Loaddata(filename)
Loads the data for a six-column xfoil file. Entries are separated by tabs.
# Arguments
- filename - Address of airfoil file to be loaded.
# Outputs
- alpha - Angles of attack from the file.
- cl - Lift coefficients from the file.
- cd - Drag coefficients from the file.
"""
function Loaddata(filename)
    xfoildata = readdlm(filename, '\t', Float64, '\n') # Divided by tabs and newlines
    alpha = xfoildata[:, 1] * pi/180 # Convert degrees to radians
    cl = xfoildata[:, 2] # cl in 2nd column
    cd = xfoildata[:, 3] # cd in 3rd column
    return alpha, cl, cd
end

"""
    intom(Rtip)
Convert the tip radius in inches to meters.
# Arguments
- Rtip - Tip radius in inches
# Outputs
- Tip radius in meters. This divides the tip diameter by 2 and then multiplies by an in-to-m conversion factor.
"""
function intom(Rtip)
    return Rtip / 2.0 * 0.0254 # Also converts diameter to radius.
end

"""
    CQCP(CP)
Does the simple calculation to convert power coefficient CP to torque coefficient CQ. CQ = CP/2pi
# Arguments
- CP - Power coefficient
# Outputs
- CQ - The torque coefficient, found by dividing the power coefficient by 2pi.
"""
function CQCP(CP)
    CQ = CP / (2 * pi) # Performs arithmetic
    return CQ
end

"""  
    CPCQ(CQ)
Converts torque coefficient CQ to power coefficient CP. CP = CQ * 2pi. Similar to CQCP(CP)
# Arguments
- CQ - Torque coefficient
# Outputs
- CP - The power coefficient, found by multiplying the torque coefficient by 2pi.
"""
function CPCQ(CQ)
    CP = CQ * (2 * pi) # Perform arithmetic
    return CP
end

"""
    CDCPeff(rpm, rotor, sections, r, D; nJ = 20, rho = 1.225)
Find the coefficients of Thrust, Power, and Efficiency at different angles.
# Arguments
- rpm - Revolutions per minute of rotor.
- rotor - Rotor geometry created previouly in the Rotor function in the Compute section.
- sections - section properties along rotor defined in Compute function.
- r - Propellor radius from file multiplied by propellor radius.
- D - Propellor outer diameter.
- nJ - Lengths of advance ratios. Default 20.
- rho - Air density. Default 1.225.
- expr - the provided range of the experimental J values. Default 0 (none)
# Outputs
- J - A vector of non-dimensional angles of attack.
- eff - Efficiencies to go with each angle of attack.
- CT - Thrust coefficient corresponding to each entry of J.
- CQ - Torque coefficients corresponding to each J.
"""
function CDCPeff(rpm, rotor, sections, r, D; nJ = 20, rho = 1.225, expr = 0)
    Omega = rads(rpm) # Rotational Velocity in rad/s
    if expr == 0
        J = range(0.1, 0.6, length = nJ)  # advance ratio
    end
    if expr != 0
        J = expr
    end
    n = rev(Omega) # Convert rad/s to rev/s
    eff = zeros(nJ) # Zeros vector for efficiency
    CT = zeros(nJ) # Zeros vector for CT
    CQ = zeros(nJ) # Zeros vector for CQ
    for i = 1:nJ
        local Vinf = J[i] * D * n # Calculates freestream velocity
        local op = simple_op.(Vinf, Omega, r, rho) # Create operating point object to solve
        outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
        T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
        eff[i], CT[i], CQ[i] = nondim(T, Q, Vinf, Omega, rho, rotor, "propeller") # Nondimensionalize output to make useable data
    end
    return J, eff, CT, CQ
end

"""
    Compute(;Rtip = 10, Rhub = 0.10, Re0 = 1e6, B = 2, rpm = 5400, propgeom = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x7.txt", foilname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412_1e6.dat", twist = 0)
Find J, eff, CT, and CQ for a rotor of provided geometry.
# Arguments
- Rtip - Airfoil tip radius. Default 10
- Rhub - Airfoil hub radius, in decimal of tip radius. Default 0.1
- Re0 - Reynolds number. Default 10^6
- B - Blade count. Default 2
- rpm - Revolutions per minute. Default 5400
- propgeom - Propellor to be used. Default "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x7.txt"
- foilname - Airfoil to be used. Default "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat"
- twist - twist of entire airfoil in degrees. Default 0.
- chordfact - Magnitude of chord factor. Default 1.
# Outputs
- J - A vector of non-dimensional angles of attack.
- eff - The efficiency corresponding to each J.
- CT - The thrust coefficient corresponding to each J.
- CQ - The torque coefficient corresponding to each J.
"""
function Compute(;Rtip = 10, Rhub = 0.10, Re0 = 0, B = 2, rpm = 5400, nJ = 20, rho = 1.225, re = 1e6, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x7.txt", foilname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412_1e6.dat", twist = 0, expr = 0, chordfact = 1.0)
    # The first section creates the propellor.
    Rtip = intom(Rtip)  # Diameter to radius, inches to meters
    Rhub = Rhub * Rtip # Hub radius argument is a decmimal of the tip.
    if Re0 != 0 # I tried to make the rotor function work with different reynolds numbers, but its output was even further off.
        pg = PrandtlGlauert() # Gives a correction for the mach number.
        td = TransonicDrag(0.65) # Another mach number correction. I may not use either of these.
        sf = TurbulentSkinFriction(Re0) # Convert Reynolds number into useable form.
        du = DuSeligEggers() # Calculate rotation correction factor.
        rotor = Rotor(Rhub, Rtip, B#=, rotation = du, re = sf, mach = td=#) # Create rotor with skin friction.
    end
    if Re0 == 0
        rotor = Rotor(Rhub, Rtip, B) # Create rotor
    end
    D = 2 * Rtip # Diameter to radius

    # Propellor geometry
    propgeom = readdlm(propname)
    r = Convert(propgeom[:, 1], Rtip) # Translate geometry from propellor percentatge to actual distance
    chord = Convert(propgeom[:, 2], Rtip) # Translate chord to actual distance
    chord = chord .* chordfact
    theta = rad(propgeom[:, 3]) # Convert degrees to radians
    # Find airfoil data at a variety of attack angles
    af = AlphaAF(foilname)

    # This section adds twist to a propellor's twist distribution if applicable.
    if twist != 0
        for i in eachindex(theta)
            theta[i] += twist # Add twist to each segment.
        end
    end

    # This section reads in experimental data and estimates results.
    sections = Section.(r, chord, theta, Ref(af)) # Define properties for individual sections
    J, eff, CT, CQ = CDCPeff(rpm, rotor, sections, r, D; nJ = nJ, rho = rho, expr) # This is an internal function in this file.

    # Return these outputs.
    return J, eff, CT, CQ
end

struct TransonicDrag <: MachCorrection
    Mcc  # crest critical Mach number
end