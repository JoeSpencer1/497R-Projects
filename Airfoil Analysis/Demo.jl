using Xfoil, Printf

# extract geometry
x = Float64[]
y = Float64[]

f = open("Documents/GitHub/497R-Projects/naca2412.txt", "r")

for line in eachline(f)
    entries = split(chomp(line))
    push!(x, parse(Float64, entries[1]))
    push!(y, parse(Float64, entries[2]))
end

close(f)

# set operating conditions
alpha = -10:1:10
re = 1e5

c_l, c_d, c_dp, c_m, converged = Xfoil.alpha_sweep(x, y, alpha, re, iter=100, zeroinit=false, printdata=true)