#=---------------------------------------------------------------
10/10/2022
Rotor Analysis v3 Rotor_Analysis.jl
This file will use the functions in Rotor_Functions.jl to create
and analyze rotors using CCBlade. I am following the example code
to get it to work.
The APC 10x7 Propeller. Consider the effect of advance ratio (J) 
on: the coefficient of thrust (CT), 
the coefficient of torque (CQ), 
the coefficient of power (CP), 
and efficiency (η). 
Compare to experimental data found on the UIUC propeller 
database. Consider the affect of at least the radius, chord 
distribution, and twist distribution on relevant model outputs.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

# The first section creates the propellor.
J1, eff1, CT1, CQ1 = Compute(10)

# This section reads in experimental data and estimates results.
Jexp1, CTexp1, CPexp1, etaexp1 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/10x7_3008.txt")

#=---------------------------------------------------------------
This section creates graphs. comparisons.
CT is the coefficient of thrust, CQ is the coefficient of torque,
CP is the coefficient of power, and η is the efficiency.
---------------------------------------------------------------=#
for i = 1:1
    plot(J1, CT1, label = "predicted", xlabel = "\\alpha", ylabel = "\$C_{T}\$")
    plot!(Jexp1, CTexp1, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_1.png")
    plot(J1, CQ1, label = "predicted", xlabel = "\\alpha", ylabel = "\$C_{Q}\$")
#    plot!(Jexp, CQexp, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_2.png")
    plot(Jexp1, CPexp1, label = "experimental", xlabel = "\\alpha", ylabel = "\$C_{P}\$")
#    plot(J, CP, label = "predicted")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_3.png")
    plot(J1, eff1, label = "predicted", xlabel = "\\alpha", ylabel = "\\eta")
    plot!(Jexp1, etaexp1, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_4.png")
end

# This section compares different tip radii.
J2, eff2, CT2, CQ2 = Compute(12)
J3, eff3, CT3, CQ3 = Compute(8)

for i = 1:1
    plot(J1, CT1, label = "D = 10'", xlabel = "\\alpha", ylabel = "\$C_{T}\$")
    plot!(J2, CT2, label = "D = 12'")
    plot!(J3, CT3, label = "D = 8'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_5.png")
    plot(J1, CQ1, label = "D = 10'", xlabel = "\\alpha", ylabel = "\$C_{Q}\$")
    plot!(J2, CT2, label = "D = 12'")
    plot!(J3, CT3, label = "D = 8'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_6.png")
    plot(J1, eff1, label = "D = 10'", xlabel = "\\alpha", ylabel = "\\eta")
    plot!(J2, eff2, label = "D = 12'")
    plot!(J3, eff3, label = "D = 8'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_7.png")
end

# This section compares different twist distributions.
J4, eff4, CT4, CQ4 = Compute(10, twist = -0.5)
J5, eff5, CT5, CQ5 = Compute(10, twist = 0.5)

for i = 1:1
    plot(J1, CT1, label = "twist = 0˚", xlabel = "\\alpha", ylabel = "\$C_{T}\$")
    plot!(J4, CT4, label = "twist = -0.5˚")
    plot!(J5, CT5, label = "twist = 0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_8.png")
    plot(J1, CQ1, label = "twist = 0˚", xlabel = "\\alpha", ylabel = "\$C_{Q}\$")
    plot!(J4, CT4, label = "twist = -0.5˚")
    plot!(J5, CT5, label = "twist = 0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_9.png")
    plot(J1, eff1, label = "twist = 0˚", xlabel = "\\alpha", ylabel = "\\eta")
    plot!(J4, eff4, label = "twist = -0.5˚")
    plot!(J5, eff5, label = "twist = 0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_10.png")
end

# This section compares different propellor chord distributions.
J6, eff6, CT6, CQ6 = Compute(10, filename = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x4_7.txt")
J7, eff7, CT7, CQ7 = Compute(10, filename = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_11x7.txt")

for i = 1:1
    plot(J1, CT1, label = "APC 10x7", xlabel = "\\alpha", ylabel = "\$C_{T}\$")
    plot!(J6, CT6, label = "APC 10x4.7")
    plot!(J7, CT7, label = "APC 11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_11.png")
    plot(J1, CQ1, label = "APC 10x7", xlabel = "\\alpha", ylabel = "\$C_{Q}\$")
    plot!(J6, CT6, label = "APC 10x4.7")
    plot!(J7, CT7, label = "APC 11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_12.png")
    plot(J1, eff1, label = "APC 10x7", xlabel = "\\alpha", ylabel = "\\eta")
    plot!(J6, eff6, label = "APC 10x4.7")
    plot!(J7, eff7, label = "APC 11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_13.png")
end