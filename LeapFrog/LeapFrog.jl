#=---------------------------------------------------------------
7/25/2022
LeapFrogging v10 LeapFrog.jl

This program uses the equation V=(Γ*r)/(2πr^2) to calculate the
trajectories of leapfrogging vortices for a variety of starting
conditions.
---------------------------------------------------------------=#

# Sometimes it has trouble including these libraries with a loop.
using DelimitedFiles, Printf, Plots

# I included all of the functions in another file.
include("LeapFrog_Functions.jl")

#=---------------------------------------------------------------
Arguments for this function are: 
findtrajectory(steps, dt, Γ[A, B], Ai[x, z], dAi[x, z], Bi[x, z], 
dBi[x, z], figuretitle, giftitle)
---------------------------------------------------------------=#

# This first animation demonstrates the lepafrogging behavior.
findtrajectory(1000, 0.1, [1.0, 1.0], [1.0, 1.0], [0, 0], [-1.0, 1.0], [0, 0], "Desktop/Graph_A.png", "Desktop/Gif_A.gif")

# In this second animation, the vorticity of the second vortex is reversed.
findtrajectory(1000, 0.1, [1.0, -1.0], [1.0, 1.0], [0, 0], [-1.0, 1.0], [0, 0], "Desktop/Graph_B.png", "Desktop/Gif_B.gif")

# In this third animation, the first vortex is made 2 times stronger.
findtrajectory(1000, 0.1, [2.0, 1.0], [1.0, 1.0], [0, 0], [-1.0, 1.0], [0, 0], "Desktop/Graph_C.png", "Desktop/Gif_C.gif")

# In this fourth animation, the vortices are moved 2 times further apart.
findtrajectory(1000, 0.1, [1.0, 1.0], [2.0, 2.0], [0, 0], [-2.0, 2.0], [0, 0], "Desktop/Graph_D.png", "Desktop/Gif_D.gif")

# In this fifth animation, the first vortex is given an initial velocity.
findtrajectory(1000, 0.1, [1.0, 1.0], [1.0, 1.0], [0.006, 0.008], [-1.0, 1.0], [0, 0], "Desktop/Graph_E.png", "Desktop/Gif_E.gif")

# The sixth animation shows the results if both vortices are made 3 times as strong, but it is tilted.
findtrajectory(1000, 0.1, [3.0, 3.0], [1.0, 1.0], [0.2, 0.1], [-1.0, 1.0], [0.2, 0.1], "Desktop/Graph_F.png", "Desktop/Gif_F.gif")

# This animation shows two smaller vorticities with greater circulations.
findtrajectory(1000, 0.1, [2.5, 2.5], [0.75, 0.75], [0.2, 0], [-0.8, 0.6], [0, 0], "Desktop/Graph_G.png", "Desktop/Gif_G.gif")

# Copy of first animation, with faster frame rate.
findtrajectory(1000, 0.01, [1.0, 1.0], [1.0, 1.0], [0, 0], [-1.0, 1.0], [0, 0], "Desktop/Graph_A.png", "Desktop/Gif_A.gif")

# Copy of first animation, with slower frame rate.
findtrajectory(1000, 1.0, [1.0, 1.0], [1.0, 1.0], [0, 0], [-1.0, 1.0], [0, 0], "Desktop/Graph_A.png", "Desktop/Gif_A.gif")