#=---------------------------------------------------------------
9/1/2022
Airfoil_Analysis v1 Airfoil_Analysis.jl
My first iteration of the airfoil analysis uses a header file to
gain basic understanding of the code to describe airfoils.
---------------------------------------------------------------=#
# Use these libraries
using Xfoil, Printf, Plots

# This header files contains functons to simplify here.
include("Airfoil_Functions.jl")

#=---------------------------------------------------------------
Get provoded geometry for an airfoil. These geometries are from 
https://m-selig.ae.illinois.edu/ads/coord_database.html.
---------------------------------------------------------------=#
loadairfoil("Documents/GitHub/497R-Projects/naca633618.txt")

#=---------------------------------------------------------------
This findcoefficients function can be used to experiment with 
different Reynolds numbers. It tests different angles of attack
and then outputs a plot.
---------------------------------------------------------------=#
findcoefficients(x, y, 1e5, "Desktop/Figure1.png")

findcoefficients(x, y, 5e5, "Desktop/Figure2.png")

findcoefficients(x, y, 5e4, "Desktop/Figure3.png")

#=---------------------------------------------------------------
The thickness is doubled in thie repeat of the previous 3 lines.
---------------------------------------------------------------=#
y *= 2

findcoefficients(x, y, 1e5, "Desktop/Figure4.png")

findcoefficients(x, y, 5e5, "Desktop/Figure5.png")

findcoefficients(x, y, 5e4, "Desktop/Figure6.png")

#=---------------------------------------------------------------
This time, it is halved instead.
---------------------------------------------------------------=#
y /= 4

findcoefficients(x, y, 1e5, "Desktop/Figure7.png")

findcoefficients(x, y, 5e5, "Desktop/Figure8.png")

findcoefficients(x, y, 5e4, "Desktop/Figure9.png")
