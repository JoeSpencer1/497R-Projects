#=---------------------------------------------------------------
9/26/2022
Airfoil_Analysis v12 Airfoil_Functions.jl
This version calculates α0 and αst for each airfoil.
---------------------------------------------------------------=#
numitr = 20000
len = 1
res = 100
rearray = 10
err = 0.3

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
    filename = string("Documents/GitHub/497R-Projects/Airfoil Analysis/Airfoils/naca" , string(num) , "new.txt")
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
    return alpha, lowest, highest, c_l, c_d, c_dp, c_m, converged
end

function limscoef(x, y, increment, iterations, re, min, max)
    alpha = min:increment:max
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=iterations, zeroinit=false, printdata=false)
    return alpha, c_l, c_d, c_dp, c_m, converged
end

function findα0(x, y)
    place = 1
    α0 = 0
    if y[1] > 0
        while y[place] > 0
            place += 1
        end
    end
    if y[1] < 0
        while y[place + 1] < 0
            place += 1
        end
        α0 = x[place] - (x[place + 1] - x[place]) * y[place] / (y[place + 1] - y[place])
    end
    return α0
end

function polar(type, x, y, alpha, rel, reu, iterations, xt, yt, figuretitle)
    set_coordinates(x, y)
    re = Array{Float64}(undef, rearray, 1)
    c = Array{Float64}(undef, rearray, 1)
    c_l = Array{Float64}(undef, rearray, 1)
    c_d = Array{Float64}(undef, rearray, 1)
    c_dp = Array{Float64}(undef, rearray, 1)
    c_m = Array{Float64}(undef, rearray, 1)
    in = (reu - rel) / rearray
    re[1] = rel
    for i in 2:rearray
        re[i] = rel + (i - 1) * in
    end
    for i in 1:rearray
        c_l[i], c_d[i], c_dp[i], c_m[i], converged = solve_alpha(alpha, re[i], iter=iterations, ncrit=9)
    end
    if type == "lift"
        plotredrag(re, c_l, xt, yt, figuretitle)
    end
    if type == "drag"
        plotredrag(re, c_d, xt, yt, figuretitle)
    end
    if type == "polardrag"
        plotredrag(re, c_dp, xt, yt, figuretitle)
    end
    if type == "moment"
        plotredrag(re, c_m, xt, yt, figuretitle)
    end
end

function findslope(x, y, α0)
    i = 1
    while x[i] <= α0
        i += 1
    end
    i += 3
    slope = y[i] / (x[i] - α0)
    return slope
end

function findstall(x, y, α0, slope, max, re)
    i = 1
    stall = 0
    min = 1 + α0 - (α0 % 1.0)
    alpha = min:1:max
    c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=(numitr / 100), zeroinit=false, printdata=false)
    while i < length(alpha) && c_l[i + 1] >= c_l[i]
        i += 1
    end
    if i == length(c_l)
        fail = string("The stall angle of attack is not within the provided angle range from ", string(alpha[1]), " to ", string(alpha[length(alpha)], ".\n"))
        print(fail)
        stall = 0
    end
    if i < length(c_l) - 1
        slope = (c_l[i + 1] - c_l[i])
        stall = alpha[i]
        print(string("Critical Angle of Attack: ", string(stall), " Degrees\n"))
    end    
    return stall
end

function recordInfo(filename, x, y, a, l, max, re)
    α0 = findα0(a, l)
    sl = findslope(a, l, α0)
    st = findstall(x, y, α0, sl, max, re)
    intre::Int64 = re / 1000
    filename = string("Documents/GitHub/497R-Projects/Airfoil Analysis/Data/data_", string(filename), "_Re", string(intre), "k.txt")
    open(filename, "w") do file
        write(file, string(α0, "\n"))
        write(file, string(sl, "\n"))
        write(file, string(st))
    end
end

function plotliftdrag(c_l, c_d, figuretitle)
    plot(c_l[:], c_d[:], legend = false, xlabel = "Lift Coefficient", ylabel = "Drag Coefficient", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20)
    savefig(figuretitle)
end

function plotredrag(re, cd, xt, yt, figuretitle)
    plot(re[:], cd[:], legend = false, xlabel = xt, ylabel = yt, tickfontsize = 8, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20,)
    savefig(figuretitle)
end

function plotcoefficients(angle, c_l, c_d, c_dp, c_m, figuretitle, type)
    plot(angle[:], c_l[:], title = type, label = "Cl", xlabel = "Angle of Attack, degrees", ylabel = "Coefficient") 
    plot!(angle[:], c_d[:], label = "Cd")
    plot!(angle[:], c_dp[:], label = "Cdp")
    plot!(angle[:], c_m[:], label = "Cm")
    savefig(figuretitle)
end

function plot3coefficients(angle, a, la, b, lb, c, lc, figuretitle, ytitle)
    plot(angle[:], a[:], label = la, xlabel = "Angle of Attack, degrees", ylabel = ytitle, tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, linestyle = :solid)
    plot!(angle[:], b[:], label = lb, linestyle = :dashdot)
    plot!(angle[:], c[:], label = lc, linestyle = :dot)
    savefig(figuretitle)
end

function plot3notitle(angle, a, b, c, figuretitle, ytitle)
    plot(angle[:], a[:], xlabel = "Angle of Attack, degrees", ylabel = ytitle, legend = false, tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, background_color_legend = nothing, linestyle = :solid)
    plot!(angle[:], b[:], linestyle = :dashdot)
    plot!(angle[:], c[:], line = :dot)
    savefig(figuretitle)
end 