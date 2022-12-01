#=---------------------------------------------------------------
11/30/2022
Rotor Design v12 Rotor_Design.jl
I included the rotor optimization code to create polars at the
end of this file for the final report.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

global rread = readdlm("Rotor Design/Rotors/APC_10x7.txt") # Read rotor file.
global fread = "Rotor Design/Rotors/naca4412_1e6.dat" # Rename airfoil file.
c0 = 1.0 # Initial chord length ratio.
twist0 = 0.0 # Initial twist
rpm0 = 500 # Initial rpm
nb0 = 3 # Initial blade count
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
vert2 = [-0.1, 0.2]
vert3 = [-0.05, 0.05]

plot(J0[:], eff0[:], label = "3 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Effectiveness, \$\\eta\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 12, markersize = 10, background_color_legend = nothing, legend = false, leftmargin=10Plots.mm)
plot!(J1[:], eff1[:], label = "1 Blade")
plot!(J2[:], eff2[:], label = "2 Blades")
plot!(J3[:], eff3[:], label = "3 Blades")
plot!(h1[:], vert1[:], color = :gray, linestyle = :dash, label = "Optimized advance ratio, 0.27")
savefig("Rotor Design/Plots/Figure_1.png")

plot(J1[:], CT0[:], label = "3 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Thrust Coefficient, \$C_{T}\$", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 12, markersize = 10, background_color_legend = nothing, legend = false)
plot!(J1[:], CT1[:], label = "1 Blade")
plot!(J2[:], CT2[:], label = "2 Blades")
plot!(J3[:], CT3[:], label = "3 Blades")
plot!(h1[:], vert2[:], color = :gray, linestyle = :dash, label = "Optimized advance ratio, 0.27")
savefig("Rotor Design/Plots/Figure_2.png")

plot(J0[:], CQ0[:], label = "3 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Torque Coefficient, \$C_{Q}\$", tickfontsize = 18, xguidefontsize = 24, yguidefontsize = 24, legendfontsize = 25, markersize = 18, background_color_legend = nothing, legend = :outerright, size = (1600, 500), bottommargin = 15Plots.mm, leftmargin = 15Plots.mm)
ylims!((-0.01, 0.015))
plot!(J1[:], CQ1[:], label = "1 Blade")
plot!(J2[:], CQ2[:], label = "2 Blades")
plot!(J3[:], CQ3[:], label = "3 Blades")
plot!(h1[:], vert3[:], color = :gray, linestyle = :dash, label = "Optimized advance ratio, 0.27")
savefig("Rotor Design/Plots/Figure_3.png")

print(analysis(Op0.c, Op0.twist, Op0.rpm, Op0.nb, Op0.d, Op0.rhub, Op0.rho, Op0.v), "\n")
print(analysis(Op1.c, Op1.twist, Op1.rpm, Op1.nb, Op1.d, Op1.rhub, Op1.rho, Op1.v), "\n")
print(analysis(Op2.c, Op2.twist, Op2.rpm, Op2.nb, Op2.d, Op2.rhub, Op2.rho, Op2.v), "\n")
print(analysis(Op3.c, Op3.twist, Op3.rpm, Op3.nb, Op3.d, Op3.rhub, Op3.rho, Op3.v), "\n")

Op4 = multiopt(c0, twist0, rp = 0.1) # Perform multiple optimization for 2-blade rotor
Q4, Mn4, Mt4 = initialize(Op4.c, Op4.twist, fac = 1.0, nb = 3) # Find torque and moment values for this rotor.
J4, eff4, CT4, CQ4 = coefficients(Op4) # Create vectors of advance ratios.

h2 = [0.2, 0.2]
h3 = [0.225, 0.225]
h4 = [0.25, 0.25]
h5 = [0.275, 0.274]
h6 = [0.3, 0.3]
vert4 = [0.0, 0.8]


Op5 = multiopt(c0, twist0, rp = 0.1, lp = 0.5) # Perform multiple optimization for 2-blade rotor
Q5, Mn5, Mt5 = initialize(Op5.c, Op5.twist, fac = 1.0, nb = 3) # Find torque and moment values for this rotor.
J5, eff5, CT5, CQ5 = coefficients(Op5) # Create vectors of advance ratios.

h7 = [0.5, 0.5]
h8 = [0.525, 0.525]
h9 = [0.55, 0.55]
h10 = [0.575, 0.574]
h11 = [0.6, 0.6]

plot(J1[:], eff0[:], label = "3 Blades, Not Optimized", xlabel = "Advance Ratio, \$J\$", ylabel = "Efficiency, \$\\eta\$", tickfontsize = 18, xguidefontsize = 24, yguidefontsize = 24, legendfontsize = 25, markersize = 18, background_color_legend = nothing, legend = :outerright, size = (1600, 500), bottommargin = 15Plots.mm, leftmargin = 15Plots.mm)
plot!(J1[:], eff4[:], label = "3 Blades, Optimized")
plot!(h2[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h3[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h4[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h5[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h6[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(J1[:], eff5[:], label = "3 Blades, Optimized")
plot!(h7[:], vert4[:], color = :gray, linestyle = :dash, label = "Advance Ratios Checked")
plot!(h8[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h9[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h10[:], vert4[:], color = :gray, linestyle = :dash, label = false)
plot!(h11[:], vert4[:], color = :gray, linestyle = :dash, label = false)
savefig("Rotor Design/Plots/Figure_4.png")

open("Rotor Design/Outputs4.txt", "w") do file
    ans = string(Op4.c)
    write(file, ans)
    write(file, "\n")
    ans = string(Op4.twist * 180 / pi)
    write(file, ans)
    write(file, "\n")
    ans = string(Q4)
    write(file, ans)
    write(file, "\n")
    ans = string(Mn4)
    write(file, ans)
    write(file, "\n")
    ans = string(Mt4)
    write(file, ans)
end

c = 1.0 # Initial chord length ratio.
rpm = 500 # Initial rpm
nb = 3 # Initial blade count
d = 20 # Initial diameter
r = d / 2 # radius
rhub = 0.1 # Initial hub radius
rho = 1.225 # Default air density
v = 45 # Default rotor velocity
af = AlphaAF(fread)
    
# Create rotor.
#sections = Section.(r, chord, theta, Ref(af)) # Divides the rotor into segments to analyze separately.
omega = rpm * 2 * pi / 60 # Rotational Velocity in rad/s
rhub = r * rhub # Calculate hub length from tip length.
rotor = Rotor(rhub, r, nb) # Create rotor.

data = [
    -9.500  -0.3702   0.10257   0.09512  -0.0434   1.0000   0.0814
    -9.250  -0.3756   0.09949   0.09212  -0.0434   1.0000   0.0818
    -9.000  -0.3833   0.09645   0.08917  -0.0431   1.0000   0.0820
    -8.750  -0.3944   0.09343   0.08625  -0.0427   1.0000   0.0820
    -8.500  -0.4100   0.09047   0.08341  -0.0417   1.0000   0.0816
    -8.250  -0.4299   0.08732   0.08039  -0.0409   1.0000   0.0810
    -8.000  -0.4479   0.08303   0.07621  -0.0420   1.0000   0.0803
    -7.750  -0.4686   0.07711   0.07032  -0.0448   1.0000   0.0792
    -7.500  -0.4911   0.06887   0.06196  -0.0492   1.0000   0.0780
    -7.250  -0.4987   0.06336   0.05627  -0.0508   1.0000   0.0779
    -7.000  -0.4940   0.06087   0.05373  -0.0500   1.0000   0.0789
    -6.750  -0.4877   0.05850   0.05127  -0.0495   1.0000   0.0805
    -6.500  -0.4810   0.05518   0.04776  -0.0500   1.0000   0.0823
    -6.250  -0.4717   0.05110   0.04334  -0.0512   1.0000   0.0841
    -6.000  -0.4427   0.04575   0.03734  -0.0562   0.9950   0.0860
    -5.750  -0.4092   0.04098   0.03168  -0.0608   0.9891   0.0892
    -5.500  -0.3741   0.03906   0.02956  -0.0638   0.9834   0.0930
    -5.250  -0.3400   0.03717   0.02734  -0.0662   0.9766   0.0971
    -5.000  -0.3028   0.03484   0.02442  -0.0691   0.9709   0.1017
    -4.750  -0.2684   0.03351   0.02292  -0.0712   0.9637   0.1074
    -4.500  -0.2321   0.03231   0.02141  -0.0734   0.9571   0.1148
    -4.250  -0.1973   0.03121   0.02015  -0.0752   0.9496   0.1223
    -4.000  -0.1609   0.03030   0.01893  -0.0771   0.9427   0.1335
    -3.750  -0.1273   0.02962   0.01828  -0.0786   0.9345   0.1451
    -3.500  -0.0919   0.02897   0.01757  -0.0803   0.9272   0.1596
    -3.250  -0.0582   0.02841   0.01695  -0.0816   0.9187   0.1764
    -3.000  -0.0233   0.02793   0.01637  -0.0831   0.9109   0.1972
    -2.750   0.0107   0.02748   0.01598  -0.0844   0.9023   0.2192
    -2.500   0.0446   0.02706   0.01551  -0.0856   0.8938   0.2468
    -2.250   0.0801   0.02658   0.01509  -0.0872   0.8857   0.2797
    -2.000   0.1114   0.02617   0.01480  -0.0880   0.8763   0.3161
    -1.750   0.1483   0.02563   0.01444  -0.0897   0.8691   0.3663
    -1.500   0.1764   0.02515   0.01427  -0.0898   0.8589   0.4272
    -1.250   0.2096   0.02431   0.01404  -0.0903   0.8522   0.5434
    -1.000   0.2272   0.02363   0.01410  -0.0870   0.8414   0.7358
    -0.750   0.2803   0.02308   0.01357  -0.0906   0.8353   1.0000
    -0.500   0.3061   0.02323   0.01348  -0.0904   0.8230   1.0000
    -0.250   0.3355   0.02334   0.01335  -0.0906   0.8126   1.0000
     0.000   0.3708   0.02329   0.01309  -0.0917   0.8045   1.0000
     0.250   0.3965   0.02348   0.01312  -0.0913   0.7926   1.0000
     0.500   0.4283   0.02352   0.01300  -0.0918   0.7836   1.0000
     0.750   0.4582   0.02360   0.01294  -0.0920   0.7736   1.0000
     1.000   0.4847   0.02380   0.01304  -0.0917   0.7624   1.0000
     1.250   0.5198   0.02372   0.01284  -0.0925   0.7549   1.0000
     1.500   0.5435   0.02403   0.01307  -0.0918   0.7427   1.0000
     1.750   0.5716   0.02420   0.01317  -0.0917   0.7328   1.0000
     2.000   0.6027   0.02426   0.01315  -0.0919   0.7237   1.0000
     2.250   0.6269   0.02460   0.01344  -0.0913   0.7123   1.0000
     2.500   0.6593   0.02462   0.01341  -0.0917   0.7042   1.0000
     2.750   0.6835   0.02497   0.01374  -0.0910   0.6928   1.0000
     3.000   0.7090   0.02530   0.01406  -0.0905   0.6824   1.0000
     3.250   0.7403   0.02537   0.01410  -0.0907   0.6739   1.0000
     3.500   0.7624   0.02586   0.01461  -0.0898   0.6624   1.0000
     3.750   0.7907   0.02608   0.01484  -0.0897   0.6532   1.0000
     4.000   0.8168   0.02639   0.01517  -0.0892   0.6430   1.0000
     4.250   0.8399   0.02687   0.01568  -0.0885   0.6322   1.0000
     4.500   0.8722   0.02691   0.01573  -0.0887   0.6241   1.0000
     4.750   0.8917   0.02754   0.01645  -0.0875   0.6123   1.0000
     5.000   0.9163   0.02795   0.01691  -0.0868   0.6020   1.0000
     5.250   0.9455   0.02813   0.01714  -0.0867   0.5927   1.0000
     5.500   0.9652   0.02877   0.01788  -0.0855   0.5810   1.0000
     5.750   0.9905   0.02913   0.01831  -0.0848   0.5707   1.0000
     6.000   1.0175   0.02941   0.01867  -0.0844   0.5605   1.0000
     6.250   1.0364   0.03007   0.01946  -0.0830   0.5485   1.0000
     6.500   1.0604   0.03049   0.01997  -0.0822   0.5375   1.0000
     6.750   1.0886   0.03065   0.02021  -0.0818   0.5267   1.0000
     7.000   1.1063   0.03126   0.02095  -0.0801   0.5130   1.0000
     7.250   1.1256   0.03166   0.02145  -0.0785   0.4982   1.0000
     7.500   1.1446   0.03199   0.02187  -0.0767   0.4824   1.0000
     7.750   1.1625   0.03233   0.02232  -0.0748   0.4661   1.0000
     8.000   1.1790   0.03272   0.02281  -0.0728   0.4495   1.0000
     8.250   1.1940   0.03312   0.02328  -0.0706   0.4319   1.0000
     8.500   1.2081   0.03344   0.02364  -0.0681   0.4129   1.0000
     8.750   1.2133   0.03423   0.02456  -0.0648   0.3924   1.0000
     9.000   1.2172   0.03500   0.02539  -0.0614   0.3714   1.0000
     9.250   1.2229   0.03574   0.02611  -0.0582   0.3496   1.0000
     9.500   1.2242   0.03697   0.02742  -0.0551   0.3266   1.0000
     9.750   1.2270   0.03817   0.02858  -0.0522   0.3030   1.0000
    10.000   1.2268   0.03981   0.03022  -0.0495   0.2781   1.0000
    10.250   1.2259   0.04163   0.03197  -0.0470   0.2536   1.0000
    10.500   1.2235   0.04380   0.03406  -0.0448   0.2301   1.0000
    10.750   1.2203   0.04622   0.03636  -0.0428   0.2093   1.0000
    11.000   1.2168   0.04888   0.03897  -0.0412   0.1904   1.0000
    11.250   1.2134   0.05168   0.04171  -0.0398   0.1746   1.0000
    11.500   1.2106   0.05454   0.04452  -0.0386   0.1616   1.0000
    11.750   1.2084   0.05742   0.04733  -0.0375   0.1507   1.0000
    12.000   1.2078   0.06025   0.05018  -0.0366   0.1408   1.0000
    12.250   1.2092   0.06297   0.05295  -0.0357   0.1324   1.0000
    12.500   1.2115   0.06552   0.05546  -0.0348   0.1256   1.0000
    12.750   1.2154   0.06813   0.05820  -0.0340   0.1188   1.0000
    13.000   1.2196   0.07058   0.06067  -0.0332   0.1129   1.0000
    13.250   1.2253   0.07302   0.06320  -0.0324   0.1078   1.0000
    13.500   1.2306   0.07564   0.06601  -0.0318   0.1031   1.0000
    13.750   1.2392   0.07769   0.06807  -0.0309   0.0988   1.0000
    14.000   1.2432   0.08059   0.07115  -0.0305   0.0950   1.0000
    14.250   1.2420   0.08420   0.07504  -0.0306   0.0916   1.0000
    14.500   1.2438   0.08737   0.07836  -0.0305   0.0885   1.0000
    14.750   1.2590   0.08867   0.07955  -0.0294   0.0849   1.0000
    15.000   1.2455   0.09415   0.08542  -0.0307   0.0832   1.0000
    15.250   1.2309   0.10003   0.09162  -0.0325   0.0815   1.0000
    15.500   1.2146   0.10644   0.09830  -0.0349   0.0800   1.0000
    15.750   1.1958   0.11362   0.10573  -0.0381   0.0788   1.0000
    16.000   1.1706   0.12256   0.11492  -0.0427   0.0781   1.0000
    16.250   1.1230   0.13766   0.13029  -0.0518   0.0786   1.0000
]

alpha_0 = data[:, 1] * pi/180
cl_0 = data[:, 2]
cd_0 = data[:, 3]
cr75 = 0.128
alpha_ext, cl_ext, cd_ext = viterna(alpha_0, cl_0, cd_0, cr75)

plot(alpha_ext, cl_ext)