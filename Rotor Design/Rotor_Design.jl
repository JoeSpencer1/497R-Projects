#=---------------------------------------------------------------
11/5/2022
Rotor Design v4 Rotor_Design.jl
I got the optimizer to work and moved it to a function. It finds
two of the parameter limits, though, so I may want to change the
objective function again.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

c = 10
twist = 1
v = 20.0
rpm = 2000

optimize(c, twist, v, rpm)