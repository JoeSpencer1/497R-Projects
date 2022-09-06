#=---------------------------------------------------------------
9/5/2022
Airfoil_Analysis v2 Airfoil_Analysis.jl
My second version of the airfoil analysis julia code uses files
for airfoil data instead of multiplying by factors. I also made
the Reynolds numbers closer together.
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
const x, y = loadairfoil("Documents/GitHub/497R-Projects/naca2410.txt")

#=---------------------------------------------------------------
This findcoefficients function can be used to experiment with 
different Reynolds numbers. It tests different angles of attack
and then outputs a plot.
---------------------------------------------------------------=#
findcoefficients(x, y, 1e5, "Documents/GitHub/497R-Projects/Figure1.png", "NACA 2410, Re=1×10⁵")

findcoefficients(x, y, 5e4, "Documents/GitHub/497R-Projects/Figure2.png", "NACA 2410, Re=5×10⁴")

findcoefficients(x, y, 2e5, "Documents/GitHub/497R-Projects/Figure3.png", "NACA 2410, Re=2×10⁵")

#=---------------------------------------------------------------
These next plots try a NACA 2411 (maximum wing thickness slightly
less)
---------------------------------------------------------------=#
const x, y = loadairfoil("Documents/GitHub/497R-Projects/naca2411.txt")

findcoefficients(x, y, 1e5, "Documents/GitHub/497R-Projects/Figure4.png", "NACA 2411, Re=1×10⁵")

findcoefficients(x, y, 5e4, "Documents/GitHub/497R-Projects/Figure5.png", "NACA 2411, Re=5×10⁴")

findcoefficients(x, y, 2e5, "Documents/GitHub/497R-Projects/Figure6.png", "NACA 2411, Re=2×10⁵")

#=---------------------------------------------------------------
This an even thicker NACA 2418 airfoil.
---------------------------------------------------------------=#
const x, y = loadairfoil("Documents/GitHub/497R-Projects/naca2418.txt")

findcoefficients(x, y, 1e5, "Documents/GitHub/497R-Projects/Figure7.png", "NACA 2418, Re=1×10⁵")

findcoefficients(x, y, 5e4, "Documents/GitHub/497R-Projects/Figure8.png", "NACA 2418, Re=5×10⁴")

findcoefficients(x, y, 2e5, "Documents/GitHub/497R-Projects/Figure9.png", "NACA 2418, Re=2×10⁵")

#=---------------------------------------------------------------
The NACA 1408 airfoil has a thinner camber.
---------------------------------------------------------------=#
const x, y = loadairfoil("Documents/GitHub/497R-Projects/naca1408.txt")

findcoefficients(x, y, 1e5, "Documents/GitHub/497R-Projects/Figure10.png", "NACA 1408, Re=1×10⁵")

findcoefficients(x, y, 5e4, "Documents/GitHub/497R-Projects/Figure11.png", "NACA 1408, Re=5×10⁴")

findcoefficients(x, y, 2e5, "Documents/GitHub/497R-Projects/Figure12.png", "NACA 1408, Re=2×10⁵")

#=---------------------------------------------------------------
The NACA 4418 airfoil has a thicker camber.
---------------------------------------------------------------=#
const x, y = loadairfoil("Documents/GitHub/497R-Projects/naca4418.txt")

findcoefficients(x, y, 1e5, "Documents/GitHub/497R-Projects/Figure13.png", "NACA 4418, Re=1×10⁵")

findcoefficients(x, y, 5e4, "Documents/GitHub/497R-Projects/Figure14.png", "NACA 4418, Re=5×10⁴")

findcoefficients(x, y, 2e5, "Documents/GitHub/497R-Projects/Figure15.png", "NACA 4418, Re=2×10⁵")