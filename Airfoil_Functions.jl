#=---------------------------------------------------------------
9/15/2022
Airfoil_Analysis v8 Airfoil_Functions.jl
This file is unchanged. Airfoils were adjusted in the main file
Airfoil_Analysis.jl.
---------------------------------------------------------------=#
numitr = 20000
len = 1
res = 100

function load(filename)
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

function create(mpth, n)
    nd = n * 1.0
    n2 = n * 2 + 1
    x = Array{Float64}(undef, n2, 1)
    y = Array{Float64}(undef, n2, 1)
    for i in 1:n2
        if i < (n + 2)
            x[i] = 1 - (i - 1) / nd
        end
        if i > (n + 1)
            x[i] = (i - n - 1) / nd
        end
    end
    th = mod(mpth, 100) / 100
    p = (mod(mpth, 1000) - th * 100) / 1000
    m = (mpth - p * 1000 - th* 100) / 100000
    for i in 1:n2
        if i < n + 1
            y[i] = 5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if i > n
            y[i] = -5 * th * (0.2969 * sqrt(x[i]) - 0.1260 * x[i] - 0.3516 * x[i] ^ 2 + 0.2843 * x[i] ^ 3 - 0.1015 * x[i] ^ 4)
        end
        if x[i] <= p
            y[i] += (2 * p * x[i] - x[i] ^ 2) * m / p ^ 2
        end
        if x[i] > p 
            y[i] += ((1 - 2 * p) + 2 * p * x[i] - x[i] ^ 2) * m / (1 - p) ^ 2
        end
        
    end
    writefile(n2, x, y, m, p, th)
    return([x, y])
end

function writefile(n, x, y, m, p, th)
    num0 = m * 100000 + p * 1000 + th * 100
    num = trunc(Int64, num0)
    filename = string("Documents/GitHub/497R-Projects/naca" , string(num) , "new.txt")
    printfile = open(filename, "w")
    for i in 1:n
        write(printfile, string(x[i]))
        write(printfile, "\t")
        write(printfile, string(y[i]))
        write(printfile, "\n")
    end
    close(printfile)
end

function range(x, y, re, increment, iterations)
    lowest = 0
    highest = lowest + increment
    lowerlim = false
    upperlim = false
    alpha = lowest:increment:highest
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false) 
    while lowerlim == false
        lowest = lowest - increment
        alpha = lowest:increment:highest
        c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)  
        if converged[1] == 0
            lowerlim = true
            lowest = lowest + increment
        end
    end   
    if lowest > 0
        highest = lowest + increment
    end 
    while upperlim == false
        highest = highest + increment
        alpha = lowest:increment:highest
        c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)  
        if converged[1 + highest - lowest] == 0
            upperlim = true
            highest = highest - increment
        end
    end
    alpha = lowert:increment:highest
    return alpha
end

function convergecoef(x, y, increment, iterations, re)
    alpha = range(x, y, re, increment, numitr)
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)
    return lowest, highest, c_l, c_d, c_dp, c_m, converged
end

function limscoef(x, y, increment, iterations, re, min, max)
    alpha = min:increment:max
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)
    return c_l, c_d, c_dp, c_m, converged
end

function plotcoefficients(lowest, res, highest, c_l, c_d, c_dp, c_m, figuretitle, type)
    angle = lowest:res:highest
    plot(angle[:], c_l[:], title = type, label = "Cl", xlabel = "Angle of Attack, degrees", ylabel = "Coefficient") 
    plot!(angle[:], c_d[:], label = "Cd")
    plot!(angle[:], c_dp[:], label = "Cdp")
    plot!(angle[:], c_m[:], label = "Cm")
    savefig(figuretitle)
end

function plot2coefficients(lowest, highest, a, la, resa, b, lb, resb , figuretitle, type)
    anglea = lowest:resa:highest
    angleb = lowest:resb:highest
    plot(anglea[:], a[:], title = type, label = la, xlabel = "Angle of Attack, degrees", ylabel = "Coefficient")
    plot!(angleb[:], b[:], label = lb)
    savefig(figuretitle)
end

function plot3coefficients(lowest, res, highest, a, la, b, lb, c, lc, figuretitle, ytitle)
    angle = lowest:res:highest
    plot(angle[:], a[:], label = la, xlabel = "Angle of Attack, degrees", ylabel = ytitle)
    plot!(angle[:], b[:], label = lb)
    plot!(angle[:], c[:], label = lc)
    savefig(figuretitle)
end