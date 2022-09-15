#=---------------------------------------------------------------
9/15/2022
Airfoil_Analysis v8 Airfoil_Analysis.jl
This file uses more realistic airfoils.
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
const x1, y1 = create(1310, res)

const l1, d1, dp1, m1, c1 = limscoef(x1, y1, len, numitr, 1e5, -8, 8)

const x2, y2 = create(2310, res)

const l2, d2, dp2, m2, c2 = limscoef(x2, y2, len, numitr, 1e5, -8, 8)

const x3, y3 = create(3310, res)

const l3, d3, dp3, m3, c3 = limscoef(x3, y3, len, numitr, 1e5, -8, 8)

plot3coefficients(-8, len, 8, l1, "NACA 1310", l2, "NACA 2310", l3, "NACA 3310", "Documents/GitHub/497R-Projects/Figure1.png", "Lift Coefficient")

plot3coefficients(-8, len, 8, d1, "NACA 1310", d2, "NACA 2310", d3, "NACA 3310", "Documents/GitHub/497R-Projects/Figure2.png", "Drag Coefficient")

plot3coefficients(-8, len, 8, m1, "NACA 1310", m2, "NACA 2310", m3, "NACA 3310", "Documents/GitHub/497R-Projects/Figure3.png", "Moment Coefficient")

const x4, y4 = create(1412, res)

const l4, d4, dp4, m4, c4 = limscoef(x4, y4, len, numitr, 1e5, -8, 8)

const x5, y5 = create(2412, res)

const l5, d5, dp5, m5, c5 = limscoef(x5, y5, len, numitr, 1e5, -8, 8)

const x6, y6 = create(3412, res)

const l6, d6, dp6, m6, c6 = limscoef(x6, y6, len, numitr, 1e5, -8, 8)

plot3coefficients(-8, len, 8, l4, "NACA 1412", l5, "NACA 2412", l6, "NACA 3412", "Documents/GitHub/497R-Projects/Figure4.png", "Lift Coefficient")

plot3coefficients(-8, len, 8, d4, "NACA 1412", d5, "NACA 2412", d6, "NACA 3412", "Documents/GitHub/497R-Projects/Figure5.png", "Drag Coefficient")

plot3coefficients(-8, len, 8, m4, "NACA 1412", m5, "NACA 2412", m6, "NACA 3412", "Documents/GitHub/497R-Projects/Figure6.png", "Moment Coefficient")

#=---------------------------------------------------------------
This section explores the effects of different Reynolds numbers
on airfoil performance.
---------------------------------------------------------------=#

const x7, y7 = create(2209, res)

const l7a, d7a, dp7a, m7a, c7a = limscoef(x7, y7, len, numitr, 1e5, -8, 8)

const l7b, d7b, dp7b, m7b, c7b = limscoef(x7, y7, len, numitr, 2e5, -8, 8)

const l7c, d7c, dp7c, m7c, c7c = limscoef(x7, y7, len, numitr, 3e5, -8, 8)

plot3coefficients(-8, len, 8, l7a, "NACA 2209, Re = 10,000", l7b, "Re = 20,000", l7c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure7.png", "Lift Coefficient")

plot3coefficients(-8, len, 8, d7a, "NACA 2209, Re = 10,000", d7b, "Re = 20,000", d7c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure8.png", "Drag Coefficient")

plot3coefficients(-8, len, 8, m7a, "NACA 2209, Re = 10,000", m7b, "Re = 20,000", m7c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure9.png", "Moment Coefficient")

const x8, y8 = create(1115, res)

const l8a, d8a, dp8a, m8a, c7a = limscoef(x8, y8, len, numitr, 1e5, -8, 8)

const l8b, d8b, dp8b, m8b, c7b = limscoef(x8, y8, len, numitr, 2e5, -8, 8)

const l8c, d8c, dp8c, m8c, c7c = limscoef(x8, y8, len, numitr, 3e5, -8, 8)

plot3coefficients(-8, len, 8, l8a, "NACA 1115, Re = 10,000", l8b, "Re = 20,000", l8c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure10.png", "Lift Coefficient")

plot3coefficients(-8, len, 8, d8a, "NACA 1115, Re = 10,000", d8b, "Re = 20,000", d8c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure11.png", "Drag Coefficient")

plot3coefficients(-8, len, 8, m8a, "NACA 1115, Re = 10,000", m8b, "Re = 20,000", m8c, "Re = 30,000", "Documents/GitHub/497R-Projects/Figure12.png", "Moment Coefficient")

#=---------------------------------------------------------------
This section examines different airfoil thicknesses and cambers.
---------------------------------------------------------------=#

const x9, y9 = create(2208, res)

const l9, d9, dp9, m9, c9 = limscoef(x9, y9, len, numitr, 1e5, -8, 8)

const x10, y10 = create(2213, res)

const l10, d10, dp10, m10, c10 = limscoef(x10, y10, len, numitr, 1e5, -8, 8)

const x11, y11 = create(2218, res)

const l11, d11, dp11, m11, c11 = limscoef(x11, y11, len, numitr, 1e5, -8, 8)

plot3coefficients(-8, len, 8, l9, "NACA 2208", l10, "NACA 2213", l11, "NACA 2218", "Documents/GitHub/497R-Projects/Figure13.png", "Lift Coefficient")

plot3coefficients(-8, len, 8, d9, "NACA 2208", d10, "NACA 2213", d11, "NACA 2218", "Documents/GitHub/497R-Projects/Figure14.png", "Drag Coefficient")

plot3coefficients(-8, len, 8, m9, "NACA 2208", m10, "NACA 2213", m11, "NACA 2218", "Documents/GitHub/497R-Projects/Figure15.png", "Moment Coefficient")

const x12, y12 = create(2114, res)

const l12, d12, dp12, m12, c12 = limscoef(x12, y12, len, numitr, 1e5, -8, 8)

const x13, y13 = create(2214, res)

const l13, d13, dp13, m13, c13 = limscoef(x13, y13, len, numitr, 1e5, -8, 8)

const x14, y14 = create(2314, res)

const l14, d14, dp14, m14, c14 = limscoef(x14, y14, len, numitr, 1e5, -8, 8)

plot3coefficients(-8, len, 8, l12, "NACA 2114", l13, "NACA 2214", l14, "NACA 2314", "Documents/GitHub/497R-Projects/Figure16.png", "Lift Coefficient")

plot3coefficients(-8, len, 8, d12, "NACA 2114", d13, "NACA 2214", d14, "NACA 2314", "Documents/GitHub/497R-Projects/Figure17.png", "Drag Coefficient")

plot3coefficients(-8, len, 8, m12, "NACA 2114", m13, "NACA 2214", m14, "NACA 2314", "Documents/GitHub/497R-Projects/Figure18.png", "Moment Coefficient")