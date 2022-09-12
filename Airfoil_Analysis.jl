#=---------------------------------------------------------------
9/12/2022
Airfoil_Analysis v6 Airfoil_Analysis.jl
This updated version creates different types of graphs. I will
probably delete previously created graphs and airfoil files, 
since I have learned how to make them easily amd they mostly just
clog up my airfoil analysis folder now.
---------------------------------------------------------------=#
# Use these libraries
using Xfoil, Printf, Plots

# This header files contains functons to simplify here.
include("Airfoil_Functions.jl")

#=---------------------------------------------------------------
For this version of the code, I will only create homemade 
airfoils since that program seems to work very well. I tested
this in previous versions by comparing with airfoils found at
https://m-selig.ae.illinois.edu/ads/coord_database.html.
---------------------------------------------------------------=#

#=---------------------------------------------------------------
This first section compares airfoils with different first digits.
---------------------------------------------------------------=#
const x1, y1 = createairfoil(1430, 21)

const l1, d1, dp1, m1, c1 = limscoef(x1, y1, 1, numitr, 1e5, -10, 10)

const x2, y2 = createairfoil(2430, 21)

const l2, d2, dp2, m2, c2 = limscoef(x2, y2, 1, numitr, 1e5, -10, 10)

const x3, y3 = createairfoil(3430, 21)

const l3, d3, dp3, m3, c3 = limscoef(x3, y3, 1, numitr, 1e5, -10, 10)

plot3coefficients(-10, 1, 10, l1, "NACA 1430", l2, "NACA 2430", l3, "NACA 3430", "Documents/GitHub/497R-Projects/Figure1.png", "Lift Coefficient with Varying Camber")

plot3coefficients(-10, 1, 10, d1, "NACA 1430", d2, "NACA 2430", d3, "NACA 3430", "Documents/GitHub/497R-Projects/Figure2.png", "Drag Coefficient with Varying Camber")

plot3coefficients(-10, 1, 10, m1, "NACA 1430", m2, "NACA 2430", m3, "NACA 3430", "Documents/GitHub/497R-Projects/Figure3.png", "Moment Coefficient with Varying Camber")

const x4, y4 = createairfoil(1210, 21)

const l4, d4, dp4, m4, c4 = limscoef(x4, y4, 1, numitr, 1e5, -10, 10)

const x5, y5 = createairfoil(2210, 21)

const l5, d5, dp5, m5, c5 = limscoef(x5, y5, 1, numitr, 1e5, -10, 10)

const x6, y6 = createairfoil(3210, 21)

const l6, d6, dp6, m6, c6 = limscoef(x6, y6, 1, numitr, 1e5, -10, 10)

plot3coefficients(-10, 1, 10, l4, "NACA 1210", l5, "NACA 2210", l6, "NACA 3210", "Documents/GitHub/497R-Projects/Figure4.png", "Lift Coefficient with Varying Camber")

plot3coefficients(-10, 1, 10, d4, "NACA 1210", d5, "NACA 2210", d6, "NACA 3210", "Documents/GitHub/497R-Projects/Figure5.png", "Drag Coefficient with Varying Camber")

plot3coefficients(-10, 1, 10, m4, "NACA 1210", m5, "NACA 2210", m6, "NACA 3210", "Documents/GitHub/497R-Projects/Figure6.png", "Moment Coefficient with Varying Camber")

#=---------------------------------------------------------------
This section explores the effects of different Reynolds numbers
on airfoil performance.
---------------------------------------------------------------=#

const x7, y7 = createairfoil(2230, 21)

const l7a, d7a, dp7a, m7a, c7a = limscoef(x7, y7, 1, numitr, 1e5, -15, 15)

const l7b, d7b, dp7b, m7b, c7b = limscoef(x7, y7, 1, numitr, 2e5, -15, 15)

const l7c, d7c, dp7c, m7c, c7c = limscoef(x7, y7, 1, numitr, 3e5, -15, 15)

plot3coefficients(-15, 1, 15, l7a, "Re = 10,000", l7b, "Re = 20,000", l7c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure7.png", "NACA 2230 Lift Coefficient")

plot3coefficients(-15, 1, 15, d7a, "Re = 10,000", d7b, "Re = 20,000", d7c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure8.png", "NACA 2230 Drag Coefficient")

plot3coefficients(-15, 1, 15, m7a, "Re = 10,000", m7b, "Re = 20,000", m7c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure9.png", "NACA 2230 Moment Coefficient")

const x8, y8 = createairfoil(1120, 21)

const l8a, d8a, dp8a, m8a, c7a = limscoef(x8, y8, 1, numitr, 1e5, -15, 15)

const l8b, d8b, dp8b, m8b, c7b = limscoef(x8, y8, 1, numitr, 2e5, -15, 15)

const l8c, d8c, dp8c, m8c, c7c = limscoef(x8, y8, 1, numitr, 3e5, -15, 15)

plot3coefficients(-15, 1, 15, l8a, "Re = 10,000", l8b, "Re = 20,000", l8c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure10.png", "NACA 1120 Lift Coefficient")

plot3coefficients(-15, 1, 15, d8a, "Re = 10,000", d8b, "Re = 20,000", d8c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure11.png", "NACA 1120 Drag Coefficient")

plot3coefficients(-15, 1, 15, m8a, "Re = 10,000", m8b, "Re = 20,000", m8c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure12.png", "NACA 1120 Moment Coefficient")

#=---------------------------------------------------------------
This section examines different airfoil thicknesses and cambers.
---------------------------------------------------------------=#

const x9, y9 = createairfoil(2230, 21)

const l9, d9, dp9, m9, c9 = limscoef(x9, y9, 1, numitr, 1e5, -15, 15)

const x10, y10 = createairfoil(2235, 21)

const l10, d10, dp10, m10, c10 = limscoef(x10, y10, 1, numitr, 1e5, -15, 15)

const x11, y11 = createairfoil(2240, 21)

const l11, d11, dp11, m11, c11 = limscoef(x11, y11, 1, numitr, 1e5, -15, 15)

plot3coefficients(-15, 1, 15, l9, "NACA 2230", l10, "NACA 2235", l11, "NACA 2240", "Documents/GitHub/497R-Projects/Figure13.png", "Lift Coefficients With Varying Thickness")

plot3coefficients(-15, 1, 15, d9, "NACA 2230", d10, "NACA 2235", d11, "NACA 2240", "Documents/GitHub/497R-Projects/Figure14.png", "Drag Coefficients with Varying Thickness")

plot3coefficients(-15, 1, 15, m9, "NACA 2230", m10, "NACA 2235", m11, "NACA 2240", "Documents/GitHub/497R-Projects/Figure15.png", "Moment Coefficients with Varying Thickness")

const x12, y12 = createairfoil(2120, 21)

const l12, d12, dp12, m12, c12 = limscoef(x12, y12, 1, numitr, 1e5, -15, 15)

const x13, y13 = createairfoil(2220, 21)

const l13, d13, dp13, m13, c13 = limscoef(x13, y13, 1, numitr, 1e5, -15, 15)

const x14, y14 = createairfoil(2320, 21)

const l14, d14, dp14, m14, c14 = limscoef(x14, y14, 1, numitr, 1e5, -15, 15)

plot3coefficients(-15, 1, 15, l9, "NACA 2120", l10, "NACA 2220", l11, "NACA 2320", "Documents/GitHub/497R-Projects/Figure16.png", "Lift Coefficients With Varying Camber Distance")

plot3coefficients(-15, 1, 15, d9, "NACA 2120", d10, "NACA 2220", d11, "NACA 2320", "Documents/GitHub/497R-Projects/Figure17.png", "Drag Coefficients with Varying Camber Distance")

plot3coefficients(-15, 1, 15, m9, "NACA 2120", m10, "NACA 2220", m11, "NACA 2320", "Documents/GitHub/497R-Projects/Figure18.png", "Moment Coefficients with Varying Camber Distance")

#=---------------------------------------------------------------
I also want to examine different angle resolutions, number of
points found in the aifroil, and numbers of iterations before
stopping the xfoil program.
---------------------------------------------------------------=#