#=---------------------------------------------------------------
10/31/2022
test v1 test.jl
I used this file to prove that all of the functions worked. I
used this file to divide the code into functions.
---------------------------------------------------------------=#

using CCBlade, FLOWMath, Xfoil, Plots, LaTeXStrings, DelimitedFiles, PointerArithmetic, Optim, Setfield

rread = readdlm("Rotor Design/Rotors/APC_10x7.txt")
fread = "Rotor Design/Rotors/naca4412_1e6.dat"
D = 20 * 0.0254 # Diameter inches to meters
Rtip = D/2
c = 5
twist = 1
nb = 8
omega = 2000
v = 20
rho = 1.225
nb = 5

# Rotor geometry
r = rread[:, 1] * Rtip # Translate geometry from propellor percentatge to actual distance
chord = rread[:, 2] * Rtip .* c # Translate chord to actual distance and multiply by chord factor.
theta = rread[:, 3] * pi / 180 # Convert degrees to radians
# Find airfoil data at a variety of attack angles
af = AlphaAF(fread) # Input airfoil information. 

# This section adds twist to a propellor's twist distribution if applicable.
for i in eachindex(theta)
    theta[i] += twist # Add twist to each segment.
end

# This section reads in experimental data and estimates results.
sections = Section.(r, chord, theta, Ref(af))

rgeom = Rotor(D / 2, D / 20, nb) # Create rotor
Omega = omega * 2 * pi / 60 # Rotational Velocity in rad/s
J = v / (D * omega * 60 / (2 * pi)) # Create an advance ratio from the given information.
Rhub = Rtip / 10
rotor = Rotor(Rhub, Rtip, nb)

Vinf = J * D * omega # Calculates freestream velocity
n = Omega / (2 * pi)
for i = 1:1
    local Vinf = J * D * n # Calculates freestream velocity
    local op = simple_op.(Vinf, Omega, r, rho) # Create operating point object to solve
    outputs = solve.(Ref(rotor), sections, op) # Solves op from previous line
    T, Q = thrusttorque(rotor, sections, outputs) # Integrate the area of the calucalted curve
    eff, CT, CQ = nondim(T, Q, Vinf, Omega, rho, rotor, "propeller") # Nondimensionalize output to make useable data
    P = rho * (omega / (2 * pi)) ^ 3 * D ^ 5 * (CQ * 2 * pi)
    obj = eff * P / omega
    print(obj)
end