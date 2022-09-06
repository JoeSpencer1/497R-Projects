#=---------------------------------------------------------------
9/5/2022
Airfoil_Analysis v1 Airfoil_Functions.jl
This file contains the supporting functions for the code 
contained in Airfoil_Analysis.jl. In the second version I have
edited the graphing function to show more data in the graph. 
---------------------------------------------------------------=#
function loadairfoil(filename)
    for i in 1:1
        x = Float64[]
        y = Float64[]
        f = open(filename, "r")
        for line in eachline(f)
            entries = split(chomp(line))
            push!(x, parse(Float64, entries[1]))
            push!(y, parse(Float64, entries[2]))
        end
        close(f)
        return([x, y])
    end
end

function findcoefficients(x, y, re, figuretitle, type)
    lowest = 0
    highest = 1
    lowerlim = false
    upperlim = false
    alpha = lowest:1:highest
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=false)    
    while lowerlim == false
        lowest = lowest - 1
        alpha = lowest:1:highest
        c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=false)  
        if converged[1] == 0
            lowerlim = true
            lowest = lowest + 1
        end
    end   
    if lowest > 0
        highest = lowest + 1
    end 
    while upperlim == false
        highest = highest + 1
        alpha = lowest:1:highest
        c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=false)  
        if converged[1 + highest - lowest] == 0
            upperlim = true
            highest = highest - 1
        end
    end
    alpha = lowest:highest
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=false)
    plotcoefficients(lowest, highest, c_l, c_d, c_dp, c_m, figuretitle, type)
end

function plotcoefficients(lowest, highest, c_l, c_d, c_dp, c_m, figuretitle, type)
    angle = lowest:1:highest
    plot(angle[:], c_l[:], title = type, label = "Cl", xlabel = "Angle of Attack, degrees", ylabel = "Coefficient") 
    plot!(angle[:], c_d[:], label = "Cd")
    plot!(angle[:], c_dp[:], label = "Cdp")
    plot!(angle[:], c_m[:], label = "Cm")
    savefig(figuretitle)
end