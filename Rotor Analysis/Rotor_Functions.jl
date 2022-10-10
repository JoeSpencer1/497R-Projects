#=---------------------------------------------------------------
10/10/2022
Rotor Functions v3 Rotor_Functions.jl
This companion file for Rotor_Analysis will contain functions
used in the main file. They are mostly just conversion or airfoil
creation functions.
---------------------------------------------------------------=#

using CCBlade, FLOWMath, Xfoil, Plots, LaTeXStrings, DelimitedFiles

"""
# create
This function creates an airfoil and calculates its coefficients
of lift and drag at various points. So far this is just good for
NACA airfoils.
The name is the diameter x pitch.
"""
function create(; mpth = 4412, n = 14)
    nd = n * 1.0
    n2 = n * 2 + 1
    x = Array{Float64}(undef, n2, 1)
    y = Array{Float64}(undef, n2, 1)
    for i in 1:n2
        if i < (n + 2)
            x[i] = 1 - (i - 1) / nd
        end
        if i > (n + 1)
            x[i] = (i - n - 1) / nd
        end
    end
    th = mod(mpth, 100) / 100
    p = (mod(mpth, 1000) - th * 100) / 1000
    m = (mpth - p * 1000 - th* 100) / 100000
    for i in 1:n2
        if i < n + 1
            y[i] = 5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if i > n
            y[i] = -5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if x[i] <= p
            y[i] += (2 * p * x[i] - x[i] ^ 2) * m / p ^ 2
        end
        if x[i] > p 
            y[i] += ((1 - 2 * p) + 2 * p * x[i] - x[i] ^ 2) * m / (1 - p) ^ 2
        end
    end
    return x, y
end

"""
# coeff
This function finds the coefficients of an airfoil. Like create(),
it is borrowed from my Airfoil Analysis project.
"""
function coeff(x, y; increment = 1, iterations = 100, re = 1e6, min = -15, max = 15)
    alpha = min:increment:max
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)
    return alpha, c_l, c_d, c_dp, c_m, converged
end

"""
# rads
This simple function converts rpm to rad/s
"""
function rads(rpm)
    return rpm * 2 * pi / 60;
end

"""
# rad
This function converts rad to degress.
"""
function rad(deg)
    return deg * pi / 180
end

"""
# rev
Convers deg to radians
"""
function rev(rad)
    return rad / (2 * pi)
end

"""
# TransonicDrag
This function, copied from Guided_Example.jl, finds the drag based on a mach number.
"""
struct TransonicDrag <: MachCorrection
    Mcc  # crest critical Mach number
end

"""
# Convert
This function multiplies a proportion by the propellor tip length.
"""
function Convert(geom, rtip)
    return geom[:] * rtip
end

"""
# CTCPeff
This function finds the coefficients of Thrust, Power, and Efficiency at different angles.
"""
function CDCPeff(rpm, rotor, sections; nJ = 20, rho = 1.225)
    J = range(0.1, 0.6, length = nJ)  # advance ratio
    Omega = rad(rpm) # Rotational Velocity in rad/s
    n = rev(Omega) # Convert rad/s to rev/s
    D = 2 * Rtip # Diameter to radius
    eff = zeros(nJ)
    CT = zeros(nJ)
    CQ = zeros(nJ)
    for i = 1:nJ
        local Vinf = J[i] * D * n
        local op = simple_op.(Vinf, Omega, r, rho)
        outputs = solve.(Ref(rotor), sections, op)
        T, Q = thrusttorque(rotor, sections, outputs)
        eff[i], CT[i], CQ[i] = nondim(T, Q, Vinf, Omega, rho, rotor, "propeller")
    end
    return J, eff, CT, CQ
end

"""
# Loadexp
This function loads experimental data from a file.
"""
function Loadexp(filename)
    exp = readdlm(filename, '\t', Float64, '\n')
    Jexp = exp[:, 1]
    CTexp = exp[:, 2]
    CPexp = exp[:, 3]
    etaexp = exp[:, 4]
    return Jexp, CTexp, CPexp, etaexp
end

"""
# Loaddata
This function loads the data for a six-column xfoil file. Entries are separated by tabs.
"""
function Loaddata(filename)
    xfoildata = readdlm(filename, '\t', Float64, '\n')
    alpha = xfoildata[:, 1] * pi/180
    cl = xfoildata[:, 2]
    cd = xfoildata[:, 3]
    return alpha, cl, cd
end

"""
# intom
This function converts the tip radius in inches to meters.
"""
function intom(Rtip)
    return Rtip / 2.0 * 0.254
end

"""
# Compute
The compute function finds J, eff, CT, and CQ for a rotor of provided geometry.
"""
function Compute(Rtip; Rhub = 0.10 * Rtip, B = 2, rpm = 5400, filename = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x7.txt")
    # The first section creates the propellor.
    Rtip = intom(Rtip)  # Diameter to radius, inches to meters
    Rhub = 0.10 * Rtip # Hub radius assumed 10% of tip radius
    rotor = Rotor(Rhub, Rtip, B) # Create rotor

    # Propellor geometry
    propgeom = readdlm(filename)
    r = Convert(propgeom[:, 1], Rtip) # Translate geometry from propellor percentatge to actual distance
    chord = Convert(propgeom[:, 2], Rtip) # Translate chord to actual distance
    theta = rad(propgeom[:, 3]) # Convert degrees to radians
    # Find airfoil data at a variety of attack angles
    af = AlphaAF("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat")

    # This section reads in experimental data and estimates results.
    sections = Section.(r, chord, theta, Ref(af)) # Define properties for individual sections
    J, eff, CT, CQ = CDCPeff(rpm, rotor, sections)

    # Return these outputs.
    return J, eff, CT, CQ
end