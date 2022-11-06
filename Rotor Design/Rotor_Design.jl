#=---------------------------------------------------------------
11/5/2022
Rotor Design v5 Rotor_Design.jl
I removed the bugs from this first submission of the code and ran
it with different blade counts to find differences. This code is
ready to be submitted.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

global rread = readdlm("Rotor Design/Rotors/APC_10x7.txt") # Read rotor file.
global fread = "Rotor Design/Rotors/naca4412_1e6.dat" # Rename airfoil file.
global M = moment() # Finds limit moment
global T = torque() # Finds limit torque
c0 = 10 # Initial estimate chord length
twist0 = 1 # Initial estimate twist
v0 = 20.0 # Initial estimate for airflow velocity
rpm0 = 2000 # Initial estimate for rotational velocity

optimize(c0, twist0, v0, rpm0, nb = 2) # Optimize for 2 blades

optimize(c0, twist0, v0, rpm0, nb = 3) # Optimize for 3 blades

optimize(c0, twist0, v0, rpm0, nb = 4) # Optimize for 4 blades

optimize(c0, twist0, v0, rpm0, nb = 8) # Optimize for 8 blades