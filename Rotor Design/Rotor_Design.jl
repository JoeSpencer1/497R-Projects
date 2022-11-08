#=---------------------------------------------------------------
11/5/2022
Rotor Design v6 Rotor_Design.jl
This finished file compares several different rotors with
different blade counts in the same conditions.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

global rread = readdlm("Rotor Design/Rotors/APC_10x7.txt") # Read rotor file.
global fread = "Rotor Design/Rotors/naca4412_1e6.dat" # Rename airfoil file.
c0 = 1.1 # Initial estimate chord length
twist0 = 1 # Initial estimate twist
v0 = 20.0 # Initial estimate for airflow velocity
rpm0 = 800 # Initial estimate for rotational velocity
uc = 5.0 # Chord length limit as percentage of camber
utwist = 45 # Maximum twist in degrees
uv = 300 # Velocity limit in m/s
urpm = 1800 # Upper liimit of rpm

Q0, Mn, Mt = initialize(c0, twist0, v0, rpm0) # Find torque and moment values for this rotor.
global Q0 = Q0 # Set torque value as global.
global Mn = Mn # Set normal momenta global
global Mt = Mt # Set tangential moment global.

Op2 = optimize(c0, twist0, v0, rpm0, nb = 2) # Optimize for 2 blades

Op3 = optimize(c0, twist0, v0, rpm0, nb = 3) # Optimize for 3 blades

Op4 = optimize(c0, twist0, v0, rpm0, nb = 4) # Optimize for 4 blades

Op8 = optimize(c0, twist0, v0, rpm0, nb = 8) # Optimize for 8 blades

n = [2, 3, 4, 8] # Blade counts
c = [Op2[1], Op3[1], Op4[1], Op8[1]] # Optimal chord lengths
twist = [Op2[2], Op3[2], Op4[2], Op8[2]] # Optimal twist angles
v = [Op2[3], Op3[3], Op4[3], Op8[3]] # Optimal freestream velocity
rpm = [Op2[4], Op3[4], Op4[4], Op8[4]] # Optimal rpm

scatter(n[:], c[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Chord Length", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_1.png")

scatter(n[:], twist[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Twist Angle", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_2.png")

scatter(n[:], v[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Velocity", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0, uv))
savefig("Rotor Design/Plots/Figure_3.png")

scatter(n[:], rpm[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal RPM", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_4.png")