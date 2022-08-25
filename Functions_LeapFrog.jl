#=---------------------------------------------------------------
7/25/2022
LeapFrogging v10 Functions_LeapFrog.jl

This file contains all of the functions I used for my leapfrog
code. The first function is the one called in LeapFrog.jl.
---------------------------------------------------------------=#

function findtrajectory(steps, dt, Γ, Ai, dAi, Bi, dBi, figuretitle, giftitle)
    
    # These equations establish A and b centered around the z axis.
    A2x0 = Ai[1]
    A2z0 = -1.0 * Ai[2]
    B2x0 = Bi[1]
    B2z0 = -1.0 * Bi[2]
    ΓA1 = Γ[1]
    ΓA2 = -1 * ΓA1
    ΓB1 = Γ[2]
    ΓB2 = -1 * ΓB1

#=---------------------------------------------------------------
Create 4 arrays, for the top and bottom of each vortex. 
[x, y, z]. Also created arrays for velocities of each vortex. 
Length of array given in problem is steps.
---------------------------------------------------------------=#

    A1 = Array{Float64}(undef, steps, 3)
    dA1 = Array{Float64}(undef, steps, 3)
    A2 = Array{Float64}(undef, steps, 3)
    dA2 = Array{Float64}(undef, steps, 3)
    B1 = Array{Float64}(undef, steps, 3)
    dB1 = Array{Float64}(undef, steps, 3)
    B2 = Array{Float64}(undef, steps, 3)
    dB2 = Array{Float64}(undef, steps, 3)

    # Initialize A1, A2, B1, B2, and velocities
    initializexyz(A1, Ai[1], 0, Ai[2])
    initializexyz(A2, A2x0, 0, A2z0)
    initializexyz(B1, Bi[1], 0, Bi[2])
    initializexyz(B2, B2x0, 0, B2z0)
    initializevelocity(steps, dA1, dA2, dB1, dB2, dAi, dBi)

    for i = 2:steps
        takestep(A1, A2, B1, B2, dA1, dA2, dB1, dB2, ΓA1, ΓA2, ΓB1, ΓB2, dt, i)
    end
    
    plotfigure(A1, A2, B1, B2, figuretitle)

    creategif(A1, A2, B1, B2, steps, giftitle)
end

function initializexyz(list, x0, y0, z0)
    list[1, 1] = x0
    list[1, 2] = y0
    list[1, 3] = z0
end

function moveforward(Loc, Vel, i, t)
    for j in 1:3
        Loc[i, j] = Loc[i - 1, j] + Vel[i - 1, j] * t
    end
end

function findvelocity(p1, p2, v1, v2, Γ1, Γ2, i)
#=---------------------------------------------------------------
Once again, v is found by V=(Γ*r)/(2πr^2). This function assumes
for simplicity and appearance of output graphs that vorticity is 
entirely in the y direction and initial positions are entirely 
contained in x and z directions.
---------------------------------------------------------------=#
    h = i - 1
    r2 = (p1[h, 1] - p2[h, 1]) ^ 2 + (p1[h, 3] - p2[h, 3]) ^ 2
    v1[i, 1] += Γ2 * (p2[h, 3] - p1[h, 3]) / (2 * π * r2)
    v1[i, 2] = 0
    v1[i, 3] += Γ2 * (p1[h, 1] - p2[h, 1]) / (2 * π * r2)
    v2[i, 1] += Γ1 * (p1[h, 3] - p2[h, 3]) / (2 * π * r2) 
    v2[i, 2] = 0
    v2[i, 3] += Γ1 * (p2[h, 1] - p1[h, 1]) / (2 * π * r2)
end

function takestep(A1, A2, B1, B2, dA1, dA2, dB1, dB2, ΓA1, ΓA2, ΓB1, ΓB2, dt, i)
    # Find vA, vB, vC, and vD
    findvelocity(A1, A2, dA1, dA2, ΓA1, ΓA2, i)
    findvelocity(A1, B1, dA1, dB1, ΓA1, ΓB1, i)
    findvelocity(A1, B2, dA1, dB2, ΓA1, ΓB2, i)
    findvelocity(A2, B1, dA2, dB1, ΓA2, ΓB1, i)
    findvelocity(A2, B2, dA2, dB2, ΓA2, ΓB2, i)
    findvelocity(B1, B2, dB1, dB2, ΓB1, ΓB2, i)
    # Find new A, B, C, D
    moveforward(A1, dA1, i, dt)
    moveforward(A2, dA2, i, dt)
    moveforward(B1, dB1, i, dt)
    moveforward(B2, dB2, i, dt)
end

function plotfigure(A1, A2, B1, B2, figuretitle)
    for i in 1:1
        plot(A1[:, 1], A1[:, 3], label = "A", color = "Blue", xlabel = "x", ylabel = "z")
        plot!(A2[:, 1], A2[:, 3], label = "", color = "Blue")
        plot!(B1[:, 1], B1[:, 3], label = "B", color = "Red")
        plot!(B2[:, 1], B2[:, 3], label = "", color = "Red")
    end
    savefig(figuretitle)
end

function creategif(A1, A2, B1, B2, steps, giftitle)
    scatter((A1[1:2, 1], A1[1:2, 3]), label = "", color = "Blue", xlabel = "x", ylabel = "z")
    scatter!((A2[1:2, 1], A2[1:2, 3]), label = "", color = "Blue")
    scatter!((B1[1:2, 1], B1[1:2, 3]), label = "", color = "Red")
    scatter!((B2[1:2, 1], B2[1:2, 3]), label = "", color = "Red")
    anim = @animate for i = 3:steps
        scatter!((A1[i, 1], A1[i, 3]), label = "", color = "Blue")
        scatter!((A2[i, 1], A2[i, 3]), label = "", color = "Blue")
        scatter!((B1[i, 1], B1[i, 3]), label = "", color = "Red")
        scatter!((B2[i, 1], B2[i, 3]), label = "", color = "Red")
    end
    gif(anim, giftitle, fps = 500)
end

function initializevelocity(steps, dA1, dA2, dB1, dB2, dAi, dBi)
    for i in 1:steps
        dA1[i, 1] = dAi[1]
        dA1[i, 2] = 0
        dA1[i, 3] = dAi[2]
        dB1[i, 1] = dBi[1]
        dB1[i, 2] = 0
        dB1[i, 3] = dBi[2]
        for j in 1:3
            dA2[i, j] = dA1[i, j]
            dB2[i, j] = dB1[i, j]
        end
    end
end