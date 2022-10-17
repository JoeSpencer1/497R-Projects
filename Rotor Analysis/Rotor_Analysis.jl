#=---------------------------------------------------------------
10/17/2022
Rotor Analysis v6 Rotor_Analysis.jl
I added a short while loop in main to calculate error. I also
created a default length vector to give an x-axis for the plots.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

# Create a standard domain. This is based on known values.
J0 = range(0.1, 0.6, length = 20)

# This section reads in experimental data and estimates results.
Jexp1, CTexp1, CPexp1, etaexp1 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/10x7_6014.txt") # This experimental data was provided by UIUC.
CQexp1 = CQCP(CPexp1) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je1p = pointer(Jexp1) # Converts Jexp1 to a pointer to pass it into the Compute() function.
J1, eff1, CT1, CQ1 = Compute(10, rpm = 6014, nJ = 24, expr = Je1p) # Based on APC10x7 propellor, no rotation.
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
        error = sqrt(error) * 100 / (length(etaexp1) * sqrt(mag)) # Square root for average and divide by length
        print("eta error = ", error, "%") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CTexp1)
            error = error + (CT1[i] - CTexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + CTexp1[i] * CTexp1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / (length(CTexp1) * sqrt(mag)) # Square root for average and divide by length
        print("C_T error = ", error, "%") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CPexp1)
            error = error + (CP1[i] - CPexp1[i]) ^ 2 # Sum of squared differences
            mag = mag + CPexp1[i] * CPexp1[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / (length(CPexp1) * sqrt(mag)) # Square root for average and divide by length
        print("C_T error = ", error, "%") # Print in string.
    end
end

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
    scatter(J0, CT1, label = "D = 10'", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CT2, markershape = :square, label = "D = 20'")
    scatter!(J0, CT3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_5.png")
    scatter(J0, CQ1, label = "D = 10'", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ2, markershape = :square, label = "D = 20'")
    scatter!(J0, CQ3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_6.png")
    scatter(J0, eff1, label = "D = 10'", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff2, markershape = :square, label = "D = 20'")
    scatter!(J0, eff3, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_7.png")
end

# This section compares different twist distributions.
J4, eff4, CT4, CQ4 = Compute(10, twist = -0.5) # Twist entire fin backwards 0.5˚
J5, eff5, CT5, CQ5 = Compute(10, twist = 0.5) # Twist entire fin forwards 0.5˚

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    scatter(J0, CT1, label = "0˚", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CT4, markershape = :square, label = "-0.5˚")
    scatter!(J0, CT5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_8.png")
    scatter(J0, CQ1, label = "0˚", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :right)
    scatter!(J0, CQ4, markershape = :square, label = "-0.5˚")
    scatter!(J0, CQ5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_9.png")
    scatter(J0, eff1, label = "0˚", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff4, markershape = :square, label = "-0.5˚")
    scatter!(J0, eff5, markershape = :star5, label = "0.5˚")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_10.png")
end

# This section compares different propellor chord distributions.
# APC 10x4.7 airfoil. 
J6, eff6, CT6, CQ6 = Compute(10, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_10x4_7.txt")
# APC 11x7 airfoil.
J7, eff7, CT7, CQ7 = Compute(10, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/APC_11x7.txt")

for i = 1:1 # Visually compare the 2 airfoils calculated previously with the first airfoil
    scatter(J0, CT1, label = "10x7", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CT6, markershape = :square, label = "10x4.7")
    scatter!(J0, CT7,  markershape = :star5,label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_11.png")
    scatter(J0, CQ1, label = "10x7", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ6, markershape = :square, label = "10x4.7")
    scatter!(J0, CQ7, markershape = :star5, label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_12.png")
    scatter(J0, eff1, label = "10x7", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottom)
    scatter!(J0, eff6, markershape = :square, label = "10x4.7")
    scatter!(J0, eff7, markershape = :star5, label = "11x7")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_13.png")
end

# This plot finds the difference in expected and actual data for the example airfoil.
Jexp8, CTexp8, CPexp8, etaexp8 = Loadexp("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/0.txt") # This experimental data was provided by UIUC.
CQexp8 = CQCP(CPexp8) # Calculate CQ from CP for comparison in plots.

# The first section creates the propellor.
Je8p = pointer(Jexp8) # Converts Jexp8 to a pointer to pass it into the Compute() function.
J8, eff8, CT8, CQ8 = Compute(10, rpm = 5400, expr = Je8p, propname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/5.txt", foilname = "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat") # Based on APC10x7 propellor, no rotation.
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
        error = sqrt(error) * 100 / (length(etaexp8) * sqrt(mag)) # Square root for average and divide by length
        print("eta error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CTexp8)
            error = error + (CT8[i] - CTexp8[i]) ^ 2 # Sum of squared differences
            mag = mag + CTexp8[i] * CTexp8[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / (length(CTexp8) * sqrt(mag)) # Square root for average and divide by length
        print("C_T error = ", error, "%\n") # Print in string.
    end

    for i = 1:1
        error = 0 # Clears previous error
        mag = 0 # Total magnitude
        for i = 1:length(CPexp8)
            error = error + (CP8[i] - CPexp8[i]) ^ 2 # Sum of squared differences
            mag = mag + CPexp8[i] * CPexp8[i] # Add to total magnitude
        end
        error = sqrt(error) * 100 / (length(CPexp8) * sqrt(mag)) # Square root for average and divide by length
        print("C_T error = ", error, "%\n") # Print in string.
    end
end

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

#=
# This section compares different tip radii.
J9, eff9, CT9, CQ2 = Compute(10) # This is technically a different rotor, but it is simply scaled larger.
J10, eff10, CT10, CQ10 = Compute(10) # Scaled smaller instead of larger.

for i = 1:1 # Create similar plots. Skip the CP plot, because it is a scaled version of CQ.
    scatter(J0, CT1, label = "D = 10'", xlabel = "J", ylabel = "\$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CT10, markershape = :square, label = "D = 20'")
    scatter!(J0, CT11, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_5.png")
    scatter(J0, CQ1, label = "D = 10'", xlabel = "J", ylabel = "\$C_{Q}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
    scatter!(J0, CQ10, markershape = :square, label = "D = 20'")
    scatter!(J0, CQ11, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_6.png")
    scatter(J0, eff1, label = "D = 10'", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomright)
    scatter!(J0, eff10, markershape = :square, label = "D = 20'")
    scatter!(J0, eff11, markershape = :star5, label = "D = 5'")
    savefig("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Plots/Figure_7.png")
end
=#

Rtip = 10/2.0 * 0.0254  # inches to meters
Rhub = 0.10*Rtip
B = 2  # number of blades
rotor = Rotor(Rhub, Rtip, B)
propgeom = [
    0.15   0.109   34.86
    0.20   0.132   37.60
    0.25   0.155   36.15
    0.30   0.175   33.87
    0.35   0.192   31.25
    0.40   0.206   28.48
    0.45   0.216   25.60
    0.50   0.222   22.79
    0.55   0.225   20.49
    0.60   0.224   18.70
    0.65   0.219   17.14
    0.70   0.210   15.64
    0.75   0.197   14.38
    0.80   0.180   13.11
    0.85   0.159   11.83
    0.90   0.133   10.65
    0.95   0.092   9.53
    1.00   0.049   8.43
]
r = propgeom[:, 1] * Rtip
chord = propgeom[:, 2] * Rtip
theta = propgeom[:, 3] * pi/180
af = AlphaAF("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat")
sections = Section.(r, chord, theta, Ref(af))
Vinf = 5.0
Omega = 6014*pi/30  # convert to rad/s
rho = 1.225
op = simple_op.(Vinf, Omega, r, rho)
out = solve.(Ref(rotor), sections, op)
exp1 = [
    0.408	0.1074	0.0708	0.619
    0.429	0.1032	0.0693	0.639
    0.452	0.0988	0.0678	0.658
    0.478	0.0928	0.0653	0.679
    0.500	0.0886	0.0638	0.695
    0.523	0.0847	0.0624	0.709
    0.550	0.0791	0.0602	0.722
    0.572	0.0755	0.0589	0.733
    0.594	0.0707	0.0568	0.740
    0.624	0.0643	0.0539	0.744
    0.646	0.0602	0.0520	0.748
    0.666	0.0554	0.0498	0.742
    0.697	0.0479	0.0460	0.726
    0.713	0.0438	0.0440	0.710
    0.738	0.0377	0.0409	0.679
    0.767	0.0302	0.0373	0.622
    0.787	0.0247	0.0344	0.564
    0.807	0.0184	0.0311	0.478
    0.841	0.0092	0.0262	0.297
    0.857	0.0048	0.0239	0.172
    0.886	-0.0034	0.0195	-0.153
    0.910	-0.0105	0.0156	-0.613
    0.935	-0.0178	0.0116	-1.441
    0.959	-0.0247	0.0078	-3.029
]
Jexp = exp1[:, 1]
CTexp = exp1[:, 2]
CPexp = exp1[:, 3]
etaexp = exp1[:, 4]
nJ = 24  # number of advance ratios
J = Jexp
Omega = 6014.0*pi/30
n = Omega/(2*pi)
D = 2*Rtip
eff = zeros(nJ)
CT = zeros(nJ)
CQ = zeros(nJ)
for i = 1:nJ
    local Vinf = J[i] * D * n
    local op = simple_op.(Vinf, Omega, r, rho)
    outputs = solve.(Ref(rotor), sections, op)
    T, Q = thrusttorque(rotor, sections, outputs)
    eff[i], CT[i], CQ[i] = nondim(T, Q, Vinf, Omega, rho, rotor, "propeller")
end
scatter(Jexp, eff, label = "predicted", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
scatter!(Jexp, etaexp, markershape = :square, label = "experimental")

