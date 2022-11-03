#=---------------------------------------------------------------
11/3/2022
Rotor Design v3 Rotor_Design.jl
After trying the code in test.jl, I have created this code that
actually works. I still have to learn how to optimize it, though.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

c = 10
twist = 1
v = 20.0
rpm = 2000
Analysis(c, twist, v, rpm)

function simple!(g, x)
    # objective
    f = 4*x[1]^2 - x[1] - x[2] - 2.5 + x[3] + x[4]

    # constraints
    # g[1] = -x[2]^2 + 1.5*x[1]^2 - 2*x[1] + 1
    # g[2] = x[2]^2 + 2*x[1]^2 - 2*x[1] - 4.25
    # g[3] = x[1]^2 + x[1]*x[2] - 10.0

    return f
end
x0 = [1.0; 2.0; 2.8; 1]  # starting point
ng = 3  # number of constraints
# xopt, fopt, info = minimize(simple!, x0, ng)
# x0 = [1.0; 2.0]  # starting point
lx = [-5.0, -5, -10, 2]  # lower bounds on x
ux = [5.0, 5, 10, 5]  # upper bounds on x
# ng = 3  # number of constraints
# lg = -Inf*ones(ng)  # lower bounds on g
# ug = zeros(ng)  # upper bounds on g
options = Options(solver=IPOPT())  # choosing IPOPT solver

xopt, fopt, info = minimize(simple!, x0, ng, lx, ux, lg, ug, options)

println("xstar = ", xopt)
println("fstar = ", fopt)
println("info = ", info)