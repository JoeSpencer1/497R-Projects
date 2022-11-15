#=---------------------------------------------------------------
11/10/2022
Rotor Design v7 Rotor_Design.jl
I have updated my ojective functions and added graphs.
---------------------------------------------------------------=#

include("Rotor_Functions.jl")

global rread = readdlm("Rotor Design/Rotors/APC_10x7.txt") # Read rotor file.
global fread = "Rotor Design/Rotors/naca4412_1e6.dat" # Rename airfoil file.
c0 = 1.1 # Initial estimate chord length
twist0 = 1 # Initial estimate twist
v0 = 20.0 # Initial estimate for airflow velocity
rpm0 = 800 # Initial estimate for rotational velocity
uc = 10.0 # Chord length limit as percentage of camber
utwist = 45 # Maximum twist in degrees
uv = 300 # Velocity limit in m/s
urpm = 1800 # Upper liimit of rpm

Q0, Mn, Mt, = initialize(c0, twist0) # Find torque and moment values for this rotor.
global Q0 = Q0 # Set torque value as global.
global Mn = Mn # Set normal momenta global
global Mt = Mt # Set tangential moment global.

# First set of tests

Op1 = optimize(c0, twist0, v0, rpm0, nb = 2, type = 1, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 2 blades

Op2 = optimize(c0, twist0, v0, rpm0, nb = 3, type = 1, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 3 blades

Op3 = optimize(c0, twist0, v0, rpm0, nb = 4, type = 1, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 4 blades

Op4 = optimize(c0, twist0, v0, rpm0, nb = 8, type = 1, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 8 blades

n = [2, 3, 4, 8] # Blade counts
c = [Op1[1], Op2[1], Op3[1], Op4[1]] # Optimal chord lengths
twist = [Op1[2], Op2[2], Op3[2], Op4[2]] # Optimal twist angles
v = [Op1[3], Op2[3], Op3[3], Op4[3]] # Optimal freestream velocity
rpm = [Op1[4], Op2[4], Op3[4], Op4[4]] # Optimal rpm

scatter(n[:], c[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Chord Length", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0.05, 0.15))
savefig("Rotor Design/Plots/Figure_1.png")

scatter(n[:], twist[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Twist Angle", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_2.png")

scatter(n[:], v[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Velocity", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0, uv))
savefig("Rotor Design/Plots/Figure_3.png")

scatter(n[:], rpm[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal RPM", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0, 600))
savefig("Rotor Design/Plots/Figure_4.png")

open("Rotor Design/Outputs1.txt", "w") do file
    ans = string(c[:])
    write(file, ans)
    ans = string(twist[:])
    write(file, ans)
    ans = string(v[:])
    write(file, ans)
    ans = string(rpm[:])
    write(file, ans)
    write(file, "\n\n")
end

# Second set of tests

Op5 = optimize(c0, twist0, v0, rpm0, nb = 2, type = 2, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 2 blades

Op6 = optimize(c0, twist0, v0, rpm0, nb = 3, type = 2, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 3 blades

Op7 = optimize(c0, twist0, v0, rpm0, nb = 4, type = 2, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 4 blades

Op8 = optimize(c0, twist0, v0, rpm0, nb = 8, type = 2, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 8 blades

n = [2, 3, 4, 8] # Blade counts
c = [Op5[1], Op6[1], Op7[1], Op8[1]] # Optimal chord lengths
twist = [Op5[2], Op6[2], Op7[2], Op8[2]] # Optimal twist angles
v = [Op5[3], Op6[3], Op7[3], Op8[3]] # Optimal freestream velocity
rpm = [Op5[4], Op6[4], Op7[4], Op8[4]] # Optimal rpm

scatter(n[:], c[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Chord Length", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0.05, 0.15))
savefig("Rotor Design/Plots/Figure_5.png")

scatter(n[:], twist[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Twist Angle", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_6.png")

scatter(n[:], v[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Velocity", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0, uv))
savefig("Rotor Design/Plots/Figure_7.png")

scatter(n[:], rpm[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal RPM", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0, 600)) # Upper limit selected after graph with urpm wasn't pretty.
savefig("Rotor Design/Plots/Figure_8.png")

open("Rotor Design/Outputs2.txt", "w") do file
    ans = string(c[:])
    write(file, ans)
    ans = string(twist[:])
    write(file, ans)
    ans = string(v[:])
    write(file, ans)
    ans = string(rpm[:])
    write(file, ans)
    write(file, "\n\n")
end

# Third set of tests

Op9 = optimize(c0, twist0, v0, rpm0, nb = 2, type = 3, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 2 blades

Op10 = optimize(c0, twist0, v0, rpm0, nb = 3, type = 3, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 3 blades

Op11 = optimize(c0, twist0, v0, rpm0, nb = 4, type = 3, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 4 blades

Op12 = optimize(c0, twist0, v0, rpm0, nb = 8, type = 3, uc = uc, utwist = utwist, uv = uv, urpm = urpm) # Optimize for 8 blades

n = [2, 3, 4, 8] # Blade counts
c = [Op9[1], Op10[1], Op11[1], Op12[1]] # Optimal chord lengths
twist = [Op9[2], Op10[2], Op11[2], Op12[2]] # Optimal twist angles
v = [Op9[3], Op10[3], Op11[3], Op12[3]] # Optimal freestream velocity
rpm = [Op9[4], Op10[4], Op11[4], Op12[4]] # Optimal rpm

scatter(n[:], c[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Chord Length", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_9.png")

scatter(n[:], twist[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Twist Angle", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_10.png")

scatter(n[:], v[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal Velocity", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
ylims!((0, uv))
savefig("Rotor Design/Plots/Figure_11.png")

scatter(n[:], rpm[:], legend = false, xlabel = "Blade Count", ylabel = "Optimal RPM", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, markersize = 10)
savefig("Rotor Design/Plots/Figure_12.png")

open("Rotor Design/Outputs3.txt", "w") do file
    ans = string(c[:])
    write(file, ans)
    ans = string(twist[:])
    write(file, ans)
    ans = string(v[:])
    write(file, ans)
    ans = string(rpm[:])
    write(file, ans)
end