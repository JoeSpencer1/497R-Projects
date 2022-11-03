#=---------------------------------------------------------------
11/3/2022
Rotor Design v3 Rotor_Design.jl
After trying the code in test.jl, I have created this code that
actually works. I still have to learn how to optimize it, though.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

c = 10
twist = 1
nb = 2
rpm = 20000
r = Rotortest(c, twist, nb, rpm)
Analysis(r)

f(x) = 1 / Analysis(x[1], x[2], x[3], x[4])
#optimize(f, [0.0, 0.0, 0.0, 0.0])