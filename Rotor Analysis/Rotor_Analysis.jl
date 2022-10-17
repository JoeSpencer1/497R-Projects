#=---------------------------------------------------------------
10/17/2022
Rotor Analysis v5 Rotor_Analysis.jl
This version of the code has several fixes. The most important
is that it can now find and plot the coefficients of 2 rotors
over the same domain.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

# Create a standard domain. This is based on known values.


# This section reads in experimental data and estimates results.
Jexp1, CTexp1, CPexp1, etaexp1 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/10x7_6014.txt") # This experimental data was provided by UIUC.
CQexp1 = CQCP(CPexp1) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je1p = pointer(Jexp8) # Converts Jexp1 to a pointer to pass it into the Compute() function.
J1, eff1, CT1, CQ1 = Compute(10, rpm = 6014, expr = Je1p) # Based on APC10x7 propellor, no rotation.
CP1 = CPCQ(CQ1) # Calculate CP from CQ for use in plots later

#=---------------------------------------------------------------
This section creates graphs. comparisons.
CT is the coefficient of thrust, CQ is the coefficient of torque,
CP is the coefficient of power, and η is the efficiency.
---------------------------------------------------------------=#
for i = 1:1
    scatter(Jexp1, CT1, label = "predicted", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, CTexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_1.png")
    scatter(Jexp1, CQ1, label = "predicted", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, CQexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_2.png")
    scatter(Jexp1, CP1, label = "predicted", xlabel = "J", ylabel = "\$C_{P}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, CPexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_3.png")
    scatter(Jexp1, eff1, label = "predicted", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, etaexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_4.png")
end

# This section compares different tip radii.
J2, eff2, CT2, CQ2 = Compute(20) # This is technically a different rotor, but it is simply scaled larger.
J3, eff3, CT3, CQ3 = Compute(5) # Scaled smaller instead of larger.

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    scatter(J1, CT1, label = "D = 10'", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J2, CT2, markershape = :square, label = "D = 20'")
    scatter!(J3, CT3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_5.png")
    scatter(J1, CQ1, label = "D = 10'", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J2, CQ2, markershape = :square, label = "D = 20'")
    scatter!(J3, CQ3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_6.png")
    scatter(J1, eff1, label = "D = 10'", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J2, eff2, markershape = :square, label = "D = 20'")
    scatter!(J3, eff3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_7.png")
end

# This section compares different twist distributions.
J4, eff4, CT4, CQ4 = Compute(10, twist = -0.5) # Twist entire fin backwards 0.5˚
J5, eff5, CT5, CQ5 = Compute(10, twist = 0.5) # Twist entire fin forwards 0.5˚

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    scatter(J1, CT1, label = "0˚", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J4, CT4, markershape = :square, label = "-0.5˚")
    scatter!(J5, CT5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_8.png")
    scatter(J1, CQ1, label = "0˚", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :right)
    scatter!(J4, CQ4, markershape = :square, label = "-0.5˚")
    scatter!(J5, CQ5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_9.png")
    scatter(J1, eff1, label = "0˚", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J4, eff4, markershape = :square, label = "-0.5˚")
    scatter!(J5, eff5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_10.png")
end

# This section compares different propellor chord distributions.
# APC 10x4.7 airfoil. 
J6, eff6, CT6, CQ6 = Compute(10, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x4_7.txt")
# APC 11x7 airfoil.
J7, eff7, CT7, CQ7 = Compute(10, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_11x7.txt")

for i = 1:1 # Visually compare the 2 airfoils calculated previously with the first airfoil
    scatter(J1, CT1, label = "10x7", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J6, CT6, markershape = :square, label = "10x4.7")
    scatter!(J7, CT7,  markershape = :star5,label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_11.png")
    scatter(J1, CQ1, label = "10x7", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J6, CQ6, markershape = :square, label = "10x4.7")
    scatter!(J7, CQ7, markershape = :star5, label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_12.png")
    scatter(J1, eff1, label = "10x7", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottom)
    scatter!(J6, eff6, markershape = :square, label = "10x4.7")
    scatter!(J7, eff7, markershape = :star5, label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_13.png")
end

# This plot finds the difference in expected and actual data for the example airfoil.
Jexp8, CTexp8, CPexp8, etaexp8 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/0.txt") # This experimental data was provided by UIUC.
CQexp8 = CQCP(CPexp8) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je8p = pointer(Jexp8) # Converts Jexp8 to a pointer to pass it into the Compute() function.
J8, eff8, CT8, CQ8 = Compute(10, rpm = 5400, expr = Je8p, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/5.txt", foilname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat") # Based on APC10x7 propellor, no rotation.
CP8 = CPCQ(CQ8) # Calculate CP from CQ for use in plots later

#=---------------------------------------------------------------
This section creates graphs. comparisons.
CT is the coefficient of thrust, CQ is the coefficient of torque,
CP is the coefficient of power, and η is the efficiency.
---------------------------------------------------------------=#
for i = 1:1
    scatter(Jexp8, CT8, label = "predicted", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, CTexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_14.png")
    scatter(Jexp8, CQ8, label = "predicted", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, CQexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_15.png")
    scatter(Jexp8, CP8, label = "predicted", xlabel = "J", ylabel = "\$C_{P}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, CPexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_16.png")
    scatter(Jexp8, eff8, label = "predicted", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, etaexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_17.png")
end