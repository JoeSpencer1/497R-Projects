#=---------------------------------------------------------------
10/17/2022
Rotor Analysis v7 Rotor_Analysis.jl
The main file that I have finished for the initial submission.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

# Create a standard domain. This is based on known values.
J0 = range(0.1, 0.6, length = 20) # This is an actual array. Other J values returned are pointers.
J0a, eff0, CT0, CQ0 = Compute()# This provides default data.

# This section reads in experimental data and estimates results.
Jexp1, CTexp1, CPexp1, etaexp1 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/10x7_6014.txt") # This experimental data was provided by UIUC.
CQexp1 = CQCP(CPexp1) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je1p = pointer(Jexp1) # Converts Jexp1 to a pointer to pass it into the Compute() function.
J1, eff1, CT1, CQ1 = Compute(rpm = 6014, Re0 = 1e6, nJ = 24, expr = Je1p) # Based on APC10x7 propellor, no rotation.
# This function without the pointer in its argument did not work the second time I tried it.
# J1, eff1, CT1, CQ1 = Compute(10, rpm = 6014, nJ = 24, expr = Jexp1) 
CP1 = CPCQ(CQ1) # Calculate CP from CQ for use in plots later

for i in 1:1
    # Calculate error.
    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(etaexp1)
            error = error + (eff1[i] - etaexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + eff1[i] * eff1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("\neta error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CTexp1)
            error = error + (CT1[i] - CTexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + CTexp1[i] * CTexp1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("C_T error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CPexp1)
            error = error + (CP1[i] - CPexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + CPexp1[i] * CPexp1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("C_P error = ", error, "%\n") # Print in string.
    end
end

#=---------------------------------------------------------------
This section creates graphs. comparisons.
CT is the coefficient of thrust, CQ is the coefficient of torque,
CP is the coefficient of power, and η is the efficiency.
---------------------------------------------------------------=#
for i = 1:1
    plt1 = scatter(Jexp1, CT1, label = "predicted", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :topright)
    scatter!(Jexp1, CTexp1, markershape = :square, label = "experimental")
    display(plt1)
    # savefig(#="/Users/joe/Desktop/Figure_1.png"=#"/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_1.png")
    # savefig("/Users/joe/Desktop/Figure_1.png")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_1.png")

    plt2 = scatter(Jexp1, CQ1, label = "predicted", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, CQexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_2.png")
    
    plt3 = scatter(Jexp1, CP1, label = "predicted", xlabel = "J", ylabel = "\$C_{P}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, CPexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_3.png")
    
    plt4 = scatter(Jexp1, eff1, label = "predicted", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp1, etaexp1, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_4.png")
end

# This section compares different tip radii.
J2, eff2, CT2, CQ2 = Compute(Rtip = 20) # This is technically a different rotor, but it is simply scaled larger.
J3, eff3, CT3, CQ3 = Compute(Rtip = 5) # Scaled smaller instead of larger.

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    plt5 = scatter(J0, CT0, label = "D = 10'", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :topright)
    scatter!(J0, CT2, markershape = :square, label = "D = 20'")
    scatter!(J0, CT3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_5.png")
    
    plt6 = scatter(J0, CQ0, label = "D = 10'", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ2, markershape = :square, label = "D = 20'")
    scatter!(J0, CQ3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_6.png")
    
    plt7 = scatter(J0, eff0, label = "D = 10'", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff2, markershape = :square, label = "D = 20'")
    scatter!(J0, eff3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_7.png")
end

# This section compares different twist distributions.
J4, eff4, CT4, CQ4 = Compute(twist = -0.5) # Twist entire fin backwards 0.5˚
J5, eff5, CT5, CQ5 = Compute(twist = 0.5) # Twist entire fin forwards 0.5˚

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    plt8 = scatter(J0, CT0, label = "0˚", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CT4, markershape = :square, label = "-0.5˚")
    scatter!(J0, CT5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_8.png")
    
    plt9 = scatter(J0, CQ0, label = "0˚", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :right)
    scatter!(J0, CQ4, markershape = :square, label = "-0.5˚")
    scatter!(J0, CQ5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_9.png")
    
    plt10 = scatter(J0, eff0, label = "0˚", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff4, markershape = :square, label = "-0.5˚")
    scatter!(J0, eff5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_10.png")
end

# This section compares different propellor chord distributions.
# APC 10x4.7 airfoil. 
J6, eff6, CT6, CQ6 = Compute(propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x4_7.txt")
# APC 11x7 airfoil.
J7, eff7, CT7, CQ7 = Compute(propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_11x7.txt")

for i = 1:1 # Visually compare the 2 airfoils calculated previously with the first airfoil
    plt11 = scatter(J0, CT0, label = "10x7", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CT6, markershape = :square, label = "10x4.7")
    scatter!(J0, CT7,  markershape = :star5,label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_11.png")
   
    plt12 = scatter(J0, CQ0, label = "10x7", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ6, markershape = :square, label = "10x4.7")
    scatter!(J0, CQ7, markershape = :star5, label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_12.png")
    
    plt13 = scatter(J0, eff0, label = "10x7", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottom)
    scatter!(J0, eff6, markershape = :square, label = "10x4.7")
    scatter!(J0, eff7, markershape = :star5, label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_13.png")
end

# This plot finds the difference in expected and actual data for the example airfoil.
Jexp8, CTexp8, CPexp8, etaexp8 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/0.txt") # This experimental data was provided by UIUC.
CQexp8 = CQCP(CPexp8) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je8p = pointer(Jexp8) # Converts Jexp8 to a pointer to pass it into the Compute() function.
J8, eff8, CT8, CQ8 = Compute(rpm = 5400, expr = Je8p, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/5.txt", foilname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat") # Based on APC10x7 propellor, no rotation.
CP8 = CPCQ(CQ8) # Calculate CP from CQ for use in plots later

# Calculate error.
for j in 1:1
    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(etaexp8)
            error = error + (eff8[i] - etaexp8[i]) ^ 2 # Sum of squared differences
            mag = mag + eff8[i] * eff8[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("\neta error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CTexp8)
            error = error + (CT8[i] - CTexp8[i]) ^ 2 # Sum of squared differences
            mag = mag + CTexp8[i] * CTexp8[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("C_T error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CPexp8)
            error = error + (CP8[i] - CPexp8[i]) ^ 2 # Sum of squared differences
            mag = mag + CPexp8[i] * CPexp8[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / sqrt(mag) # Square root for average and divide by length
        print("C_P error = ", error, "%\n") # Print in string.
    end
end

#=---------------------------------------------------------------
This section creates graphs. comparisons.
CT is the coefficient of thrust, CQ is the coefficient of torque,
CP is the coefficient of power, and η is the efficiency.
---------------------------------------------------------------=#
for i = 1:1
    plt14 = scatter(Jexp8, CT8, label = "predicted", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, CTexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_14.png")
    
    plt15 = scatter(Jexp8, CQ8, label = "predicted", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, CQexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_15.png")
    
    plt16 = scatter(Jexp8, CP8, label = "predicted", xlabel = "J", ylabel = "\$C_{P}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, CPexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_16.png")
    
    plt17 = scatter(Jexp8, eff8, label = "predicted", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(Jexp8, etaexp8, markershape = :square, label = "experimental")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_17.png")
end

# This section compares different tip radii.
J9, eff9, CT9, CQ9 = Compute(B = 1) # This is technically a different rotor, but it is simply scaled larger.
J10, eff10, CT10, CQ10 = Compute(B = 4) # Scaled smaller instead of larger.

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    plt18 = scatter(J0, CT0, label = "2 Blades", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :topright)
    scatter!(J0, CT9, markershape = :square, label = "1 Blade")
    scatter!(J0, CT10, markershape = :star5, label = "4 Blades")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_18.png")
    
    plt19 = scatter(J0, CQ0, label = "2 Blades", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :topright)
    scatter!(J0, CQ9, markershape = :square, label = "1 Blade'")
    scatter!(J0, CQ10, markershape = :star5, label = "4 Blades")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_19.png")
    
    plt20 = scatter(J0, eff0, label = "2 Blades", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff9, markershape = :square, label = "1 Blade")
    scatter!(J0, eff10, markershape = :star5, label = "4 Blades")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_20.png")
end

# This section finds the effect of increasing or decreasing the chord.
J11, eff11, CT11, CQ11 = Compute(chordfact = 0.8)
J12, eff12, CT12, CQ12 = Compute(chordfact = 1.2)

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    plt21 = scatter(J0, CT0, label = "100% Chord", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :topright)
    scatter!(J0, CT11, markershape = :square, label = "80% Chord")
    scatter!(J0, CT12, markershape = :star5, label = "120% Chord")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_21.png")
    
    plt19 = scatter(J0, CQ0, label = "100% Chord", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ11, markershape = :square, label = "80% Chord")
    scatter!(J0, CQ12, markershape = :star5, label = "120% Chord")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_22.png")
    
    plt20 = scatter(J0, eff0, label = "100% Chord", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff11, markershape = :square, label = "80% Chord")
    scatter!(J0, eff12, markershape = :star5, label = "120% Chord")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_23.png")
end

# This section compares different tip radii.
J13, eff13, CT13, CQ13 = Compute(Rtip = 20, str = 2) # This is technically a different rotor, but it is simply scaled larger.
J14, eff14, CT14, CQ14 = Compute(Rtip = 5, str = 0.5) # Scaled smaller instead of larger.

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    plt5 = scatter(J0, CT0, label = "D = 10'", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :topright)
    scatter!(J0, CT13, markershape = :square, label = "D = 20'")
    scatter!(J0, CT14, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_24.png")
    
    plt6 = scatter(J0, CQ0, label = "D = 10'", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ13, markershape = :square, label = "D = 20'")
    scatter!(J0, CQ14, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_25.png")
    
    plt7 = scatter(J0, eff0, label = "D = 10'", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff13, markershape = :square, label = "D = 20'")
    scatter!(J0, eff14, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_26.png")
end

print("Done.")