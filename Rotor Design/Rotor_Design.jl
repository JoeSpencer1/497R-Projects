#=---------------------------------------------------------------
11/16/2022
Rotor Design v9 Rotor_Design.jl
This code uses the advance ratio and creates graphs of the thrust
and torque coefficients and efficienty. I have added a function
to return only the objective function.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

global rread = readdlm("Rotor Design/Rotors/APC_10x7.txt") # Read rotor file.
global fread = "Rotor Design/Rotors/naca4412_1e6.dat" # Rename airfoil file.
c0 = 1.0 # Initial chord length ratio.
twist0 = 0.0 # Initial twist
rpm0 = 500 # Initial rpm
nb0 = 2 # Initial blade count
d0 = 20 # Initial diameter
rhub0 = 0.1 # Initial hub radius
rho0 = 1.225 # Default air density
v0 = 45 # Default rotor velocity

Q0, Mn, Mt = initialize(c0, twist0) # Find torque and moment values for this rotor.
global Q0 = Q0 # Set torque value as global.
global Mn = Mn # Set normal momenta global
global Mt = Mt # Set tangential moment global.

Op0 = Rotortest(c0, twist0, rpm0, nb0, d0, rhub0, rho0, v0) # Create initial rotor
J0, eff0, CT0, CQ0 = coefficients(Op0, Jmax = 0.8) # Find thhe coefficients of the initial rotor

Op1 = optimize(c0, twist0, nb = 2) # Optimize for 2 blades
Q1, Mn1, Mt1 = initialize(Op1.c, Op1.twist, fac = 1.0, nb = 2) # Find torque and moment values for this rotor.
Op2 = optimize(c0, twist0) # Optimize for 3 blades
Q2, Mn2, Mt2 = initialize(Op2.c, Op2.twist, fac = 1.0) # Find torque and moment values for this rotor.
Op3 = optimize(c0, twist0, nb = 4) # Optimize for 4 blades
Q3, Mn3, Mt3 = initialize(Op3.c, Op3.twist, fac = 1.0, nb = 4) # Find torque and moment values for this rotor.

J1, eff1, CT1, CQ1 = coefficients(Op1, Jmax = 0.8) # Create vectors of advance ratios.
J2, eff2, CT2, CQ2 = coefficients(Op2, Jmax = 0.8) # Create vectors of advance ratios.
J3, eff3, CT3, CQ3 = coefficients(Op3, Jmax = 0.8) # Create vectors of advance ratios.


open("Rotor Design/Outputs0.txt", "w") do file
    ans = string(1.0)
    write(file, ans)
    write(file, "\n")
    ans = string(0)
    write(file, ans)
    write(file, "\n")
    ans = string(Q0)
    write(file, ans)
    write(file, "\n")
    ans = string(Mn)
    write(file, ans)
    write(file, "\n")
    ans = string(Mt)
    write(file, ans)
end
open("Rotor Design/Outputs1.txt", "w") do file
    ans = string(Op1.c)
    write(file, ans)
    write(file, "\n")
    ans = string(Op1.twist * 180 / pi)
    write(file, ans)
    write(file, "\n")
    ans = string(Q1)
    write(file, ans)
    write(file, "\n")
    ans = string(Mn1)
    write(file, ans)
    write(file, "\n")
    ans = string(Mt1)
    write(file, ans)
end
open("Rotor Design/Outputs2.txt", "w") do file
    ans = string(Op2.c)
    write(file, ans)
    write(file, "\n")
    ans = string(Op2.twist * 180 / pi)
    write(file, ans)
    write(file, "\n")
    ans = string(Q2)
    write(file, ans)
    write(file, "\n")
    ans = string(Mn2)
    write(file, ans)
    write(file, "\n")
    ans = string(Mt2)
    write(file, ans)
end
open("Rotor Design/Outputs3.txt", "w") do file
    ans = string(Op3.c)
    write(file, ans)
    write(file, "\n")
    ans = string(Op3.twist * 180 / pi)
    write(file, ans)
    write(file, "\n")
    ans = string(Q3)
    write(file, ans)
    write(file, "\n")
    ans = string(Mn3)
    write(file, ans)
    write(file, "\n")
    ans = string(Mt3)
    write(file, ans)
end

h1 = [0.27, 0.27]
vert1 = [0, 0.8]
vert2 = [-0.05, 0.2]
vert3 = [-0.005, 0.015]

plot(J0[:], eff0[:], label = "2 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Effectiveness, \$\\eta\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 12, markersize = 10, background_color_legend = nothing, legend = :bottomright)
plot!(J1[:], eff1[:], label = "1 Blade")
plot!(J2[:], eff2[:], label = "2 Blades")
plot!(J3[:], eff3[:], label = "3 Blades")
plot!(h1[:], vert1[:], color = :gray, linestyle = :dash, label = "Optimized advance ratio, 0.27")
savefig("Rotor Design/Plots/Figure_1.png")

plot(J1[:], CT0[:], label = "2 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Thrust Coefficient, \$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 12, markersize = 10, background_color_legend = nothing, legend = :bottomleft)
plot!(J1[:], CT1[:], label = "1 Blade")
plot!(J2[:], CT2[:], label = "2 Blades")
plot!(J3[:], CT3[:], label = "3 Blades")
plot!(h1[:], vert2[:], color = :gray, linestyle = :dash, label = "Optimized advance ratio, 0.27")
savefig("Rotor Design/Plots/Figure_2.png")

plot(J0[:], CQ0[:], label = "2 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Torque Coefficient, \$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 12, markersize = 10, background_color_legend = nothing, legend = :bottomleft)
plot!(J1[:], CQ1[:], label = "1 Blade")
plot!(J2[:], CQ2[:], label = "2 Blades")
plot!(J3[:], CQ3[:], label = "3 Blades")
plot!(h1[:], vert3[:], color = :gray, linestyle = :dash, label = "Optimized advance ratio, 0.27")
savefig("Rotor Design/Plots/Figure_3.png")

print(analysis(Op0.c, Op0.twist, Op0.rpm, Op0.nb, Op0.d, Op0.rhub, Op0.rho, Op0.v), "\n")
print(analysis(Op1.c, Op1.twist, Op1.rpm, Op1.nb, Op1.d, Op1.rhub, Op1.rho, Op1.v), "\n")
print(analysis(Op2.c, Op2.twist, Op2.rpm, Op2.nb, Op2.d, Op2.rhub, Op2.rho, Op2.v), "\n")
print(analysis(Op3.c, Op3.twist, Op3.rpm, Op3.nb, Op3.d, Op3.rhub, Op3.rho, Op3.v), "\n")