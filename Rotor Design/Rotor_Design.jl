#=---------------------------------------------------------------
11/5/2022
Rotor Design v5 Rotor_Design.jl
I removed the bugs from this first submission of the code and ran
it with different blade counts to find differences. This code is
ready to be submitted.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

rread = readdlm("Rotor Design/Rotors/APC_10x7.txt") # Read rotor file.
fread = "Rotor Design/Rotors/naca4412_1e6.dat" # Rename airfoil file.
c0 = 10
twist0 = 1
v0 = 20.0
rpm0 = 2000

optimize(c0, twist0, v0, rpm0, nb = 2)

optimize(c, twist, v, rpm, nb = 3)

optimize(c, twist, v, rpm, nb = 4)

optimize(c, twist, v, rpm, nb = 8)