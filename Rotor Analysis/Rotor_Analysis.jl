#=---------------------------------------------------------------
10/10/2022
Rotor Analysis v4 Rotor_Analysis.jl
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
Updated function docstrings for versioin 4.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

# The first section creates the propellor.
J1, eff1, CT1, CQ1 = Compute(10) # Based on APC10x7 propellor, no rotation.
CP1 = CPCQ(CQ1) # Calculate CP from CQ for use in plots later

# This section reads in experimental data and estimates results.
Jexp1, CTexp1, CPexp1, etaexp1 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/10x7_3008.txt") # This experimental data was provided by UIUC.
CQexp1 = CQCP(CPexp1) # Calculate CQ from CP for comparison in plots.

#=---------------------------------------------------------------
This section creates graphs. comparisons.
CT is the coefficient of thrust, CQ is the coefficient of torque,
CP is the coefficient of power, and η is the efficiency.
---------------------------------------------------------------=#
for i = 1:1
    scatter(J1, CT1, label = "predicted", xlabel = "\\alpha, radians", ylabel = "\$C_{T}\$")
    scatter!(Jexp1, CTexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_1.png")
    scatter(J1, CQ1, label = "predicted", xlabel = "\\alpha, radians", ylabel = "\$C_{Q}\$")
    scatter!(Jexp1, CQexp1, markershape = :square, label = "experimental (found from \$C_{P}\$)")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_2.png")
    scatter(J1, CP1, label = "predicted (found from \$C_{Q}\$)", xlabel = "\\alpha, radians", ylabel = "\$C_{P}\$")
    scatter!(Jexp1, CPexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_3.png")
    scatter(J1, eff1, label = "predicted", xlabel = "\\alpha, radians", ylabel = "\\eta")
    scatter!(Jexp1, etaexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_4.png")
end

# This section compares different tip radii.
J2, eff2, CT2, CQ2 = Compute(20) # This is technically a different rotor, but it is simply scaled larger.
J3, eff3, CT3, CQ3 = Compute(5) # Scaled smaller instead of larger.

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    scatter(J1, CT1, label = "D = 10'", xlabel = "\\alpha, radians", ylabel = "\$C_{T}\$")
    scatter!(J2, CT2, markershape = :square, label = "D = 20'")
    scatter!(J3, CT3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_5.png")
    scatter(J1, CQ1, label = "D = 10'", xlabel = "\\alpha, radians", ylabel = "\$C_{Q}\$")
    scatter!(J2, CQ2, markershape = :square, label = "D = 20'")
    scatter!(J3, CQ3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_6.png")
    scatter(J1, eff1, label = "D = 10'", xlabel = "\\alpha, radians", ylabel = "\\eta")
    scatter!(J2, eff2, markershape = :square, label = "D = 20'")
    scatter!(J3, eff3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_7.png")
end

# This section compares different twist distributions.
J4, eff4, CT4, CQ4 = Compute(10, twist = -0.5) # Twist entire fin backwards 0.5˚
J5, eff5, CT5, CQ5 = Compute(10, twist = 0.5) # Twist entire fin forwards 0.5˚

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    scatter(J1, CT1, label = "twist = 0˚", xlabel = "\\alpha, radians", ylabel = "\$C_{T}\$")
    scatter!(J4, CT4, markershape = :square, label = "twist = -0.5˚")
    scatter!(J5, CT5, markershape = :star5, label = "twist = 0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_8.png")
    scatter(J1, CQ1, label = "twist = 0˚", xlabel = "\\alpha, radians", ylabel = "\$C_{Q}\$")
    scatter!(J4, CQ4, markershape = :square, label = "twist = -0.5˚")
    scatter!(J5, CQ5, markershape = :star5, label = "twist = 0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_9.png")
    scatter(J1, eff1, label = "twist = 0˚", xlabel = "\\alpha, radians", ylabel = "\\eta")
    scatter!(J4, eff4, markershape = :square, label = "twist = -0.5˚")
    scatter!(J5, eff5, markershape = :star5, label = "twist = 0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_10.png")
end

# This section compares different propellor chord distributions.
# APC 10x4.7 airfoil. 
J6, eff6, CT6, CQ6 = Compute(10, filename = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x4_7.txt")
# APC 11x7 airfoil.
J7, eff7, CT7, CQ7 = Compute(10, filename = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_11x7.txt")

for i = 1:1 # Visually compare the 2 airfoils calculated previously with the first airfoil
    scatter(J1, CT1, label = "APC 10x7", xlabel = "\\alpha", ylabel = "\$C_{T}\$")
    scatter!(J6, CT6, markershape = :square, label = "APC 10x4.7")
    scatter!(J7, CT7,  markershape = :star5,label = "APC 11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_11.png")
    scatter(J1, CQ1, label = "APC 10x7", xlabel = "\\alpha", ylabel = "\$C_{Q}\$")
    scatter!(J6, CQ6, markershape = :square, label = "APC 10x4.7")
    scatter!(J7, CQ7, markershape = :star5, label = "APC 11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_12.png")
    scatter(J1, eff1, label = "APC 10x7", xlabel = "\\alpha", ylabel = "\\eta")
    scatter!(J6, eff6, markershape = :square, label = "APC 10x4.7")
    scatter!(J7, eff7, markershape = :star5, label = "APC 11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_13.png")
end