#=---------------------------------------------------------------
9/7/2022
Airfoil_Analysis v5 Airfoil_Analysis.jl
This version is capable of finding different resolutions of
describing airfoils.
---------------------------------------------------------------=#
# Use these libraries
using Xfoil, Printf, Plots

# This header files contains functons to simplify here.
include("Airfoil_Functions.jl")

#=---------------------------------------------------------------
Get provoded geometry for an airfoil. These geometries are from 
https://m-selig.ae.illinois.edu/ads/coord_database.html. In the
second version of this code, I have used different airfoils from
this website instead of simply multiplying y by scale factors as
in version 1.
---------------------------------------------------------------=#
const x1, y1 = loadairfoil("Documents/GitHub/497R-Projects/naca2410.txt")

#=---------------------------------------------------------------
This findcoefficients function can be used to experiment with 
different Reynolds numbers. It tests different angles of attack
and then outputs a plot.
---------------------------------------------------------------=#
findcoefficients(x1, y1, 1e5, "Documents/GitHub/497R-Projects/Figure1.png", "NACA 2410, Re=1×10⁵")

findcoefficients(x1, y1, 5e4, "Documents/GitHub/497R-Projects/Figure2.png", "NACA 2410, Re=5×10⁴")

findcoefficients(x1, y1, 2e5, "Documents/GitHub/497R-Projects/Figure3.png", "NACA 2410, Re=2×10⁵")

#=---------------------------------------------------------------
These next plots try a NACA 2411 (maximum wing thickness slightly
less)
---------------------------------------------------------------=#
const x2, y2 = loadairfoil("Documents/GitHub/497R-Projects/naca2411.txt")

findcoefficients(x2, y2, 1e5, "Documents/GitHub/497R-Projects/Figure4.png", "NACA 2411, Re=1×10⁵")

findcoefficients(x2, y2, 5e4, "Documents/GitHub/497R-Projects/Figure5.png", "NACA 2411, Re=5×10⁴")

findcoefficients(x2, y2, 2e5, "Documents/GitHub/497R-Projects/Figure6.png", "NACA 2411, Re=2×10⁵")

#=---------------------------------------------------------------
This an even thicker NACA 2418 airfoil.
---------------------------------------------------------------=#
const x3, y3 = loadairfoil("Documents/GitHub/497R-Projects/naca2418.txt")

findcoefficients(x3, y3, 1e5, "Documents/GitHub/497R-Projects/Figure7.png", "NACA 2418, Re=1×10⁵")

findcoefficients(x3, y3, 5e4, "Documents/GitHub/497R-Projects/Figure8.png", "NACA 2418, Re=5×10⁴")

findcoefficients(x3, y3, 2e5, "Documents/GitHub/497R-Projects/Figure9.png", "NACA 2418, Re=2×10⁵")

#=---------------------------------------------------------------
The NACA 1408 airfoil has a thinner camber.
---------------------------------------------------------------=#
const x4, y4 = loadairfoil("Documents/GitHub/497R-Projects/naca1408.txt")

findcoefficients(x4, y4, 1e5, "Documents/GitHub/497R-Projects/Figure10.png", "NACA 1408, Re=1×10⁵")

findcoefficients(x4, y4, 5e4, "Documents/GitHub/497R-Projects/Figure11.png", "NACA 1408, Re=5×10⁴")

findcoefficients(x4, y4, 2e5, "Documents/GitHub/497R-Projects/Figure12.png", "NACA 1408, Re=2×10⁵")

#=---------------------------------------------------------------
The NACA 4418 airfoil has a thicker camber.
---------------------------------------------------------------=#
const x5, y5 = loadairfoil("Documents/GitHub/497R-Projects/naca4418.txt")

findcoefficients(x5, y5, 1e5, "Documents/GitHub/497R-Projects/Figure13.png", "NACA 4418, Re=1×10⁵")

findcoefficients(x5, y5, 5e4, "Documents/GitHub/497R-Projects/Figure14.png", "NACA 4418, Re=5×10⁴")

findcoefficients(x5, y5, 2e5, "Documents/GitHub/497R-Projects/Figure15.png", "NACA 4418, Re=2×10⁵")

#=---------------------------------------------------------------
The NACA 4412 airfoil has a thicker camber.
---------------------------------------------------------------=#
const x6, y6 = loadairfoil("Documents/GitHub/497R-Projects/naca4412.txt")

findcoefficients(x6, y6, 1e5, "Documents/GitHub/497R-Projects/Figure16.png", "NACA 4412, Re=1×10⁵")

findcoefficients(x6, y6, 5e4, "Documents/GitHub/497R-Projects/Figure17.png", "NACA 4412, Re=5×10⁴")

findcoefficients(x6, y6, 2e5, "Documents/GitHub/497R-Projects/Figure18.png", "NACA 4412, Re=2×10⁵")

#=---------------------------------------------------------------
The NACA 4418 airfoil has a thicker camber.
---------------------------------------------------------------=#
const x7, y7 = loadairfoil("Documents/GitHub/497R-Projects/naca4421.txt")

findcoefficients(x7, y7, 1e5, "Documents/GitHub/497R-Projects/Figure19.png", "NACA 4421, Re=1×10⁵")

findcoefficients(x7, y7, 5e4, "Documents/GitHub/497R-Projects/Figure20.png", "NACA 4421, Re=5×10⁴")

findcoefficients(x7, y7, 2e5, "Documents/GitHub/497R-Projects/Figure21.png", "NACA 4421, Re=2×10⁵")

#=---------------------------------------------------------------
This function tries creating an airfoil from scratch.
---------------------------------------------------------------=#

const x8, y8 = createairfoil(2410, 20)

findcoefficients(x8, y8, 1e5, "Documents/GitHub/497R-Projects/Figure22.png", "Homemade NACA 2410, Re=1×10⁵")

const x8, y8 = createairfoil(2410, 21)

findcoefficients(x8, y8, 1e5, "Documents/GitHub/497R-Projects/Figure23.png", "Homemade NACA 2410, Re=1×10⁵")