#=---------------------------------------------------------------
9/8/2022
Airfoil_Analysis v5 Airfoil_Functions.jl
This version is capable of finding different resolutions of
describing airfoils.
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

function createairfoil(mpth, n)
    nd = n * 1.0
    n2 = n * 2 + 1
    x = Array{Float64}(undef, n2, 1)
    y = Array{Float64}(undef, n2, 1)
    for i in 1:n2
        if i < (n + 2)
            x[i] = 1 - (i - 1) / nd
        end
        if i > (n + 1)
            x[i] = (i - 21) / nd
        end
    end
    th = mod(mpth, 100) / 100
    p = (mod(mpth, 1000) - th * 100) / 1000
    m = (mpth - p * 1000 - th* 100) / 100000
    for i in 1:41
        if i < 21
            y[i] = 5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if i > 20
            y[i] = -5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if x[i] <= p
            y[i] += (2 * p * x[i] - x[i] ^ 2) * m / p ^ 2
        end
        if x[i] > p 
            y[i] += ((1 - 2 * p) + 2 * p * x[i] - x[i] ^ 2) * m / (1 - p) ^ 2
        end
        
    end
    writetofile(x, y, m, p, th)
    return([x, y])
end

function writetofile(x, y, m, p, th)
    num0 = m * 100000 + p * 1000 + th * 100
    num = trunc(Int64, num0)
    filename = string("Documents/GitHub/497R-Projects/naca" , string(num) , "new.txt")
    printfile = open(filename, "w")
    for i in 1:41
        write(printfile, string(x[i]))
        write(printfile, "\t")
        write(printfile, string(y[i]))
        write(printfile, "\n")
    end
    close(printfile)
end