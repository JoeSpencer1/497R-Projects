#=---------------------------------------------------------------
9/22/2022
Airfoil_Analysis v11 Airfoil_Analysis.jl
This code has updated functions as well as new graphs.
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

const a1, l1, d1, dp1, m1, c1 = limscoef(x1, y1, len, numitr, 1e5, -8, 8)

const x2, y2 = create(2310, res)

const a2, l2, d2, dp2, m2, c2 = limscoef(x2, y2, len, numitr, 1e5, -8, 8)

const x3, y3 = create(3310, res)

const a3, l3, d3, dp3, m3, c3 = limscoef(x3, y3, len, numitr, 1e5, -8, 8)

plot3notitle(a1, l1, l2, l3, "Documents/GitHub/497R-Projects/Figure1.png", "Lift Coefficient")

plot3coefficients(a1, d1, "NACA 1310", d2, "NACA 2310", d3, "NACA 3310", "Documents/GitHub/497R-Projects/Figure2.png", "Drag Coefficient")

plot3notitle(a1, m1, m2, m3, "Documents/GitHub/497R-Projects/Figure3.png", "Moment Coefficient")

const x4, y4 = create(1412, res)

const a4, l4, d4, dp4, m4, c4 = limscoef(x4, y4, len, numitr, 1e5, -8, 8)

const x5, y5 = create(2412, res)

const a5, l5, d5, dp5, m5, c5 = limscoef(x5, y5, len, numitr, 1e5, -8, 8)

const x6, y6 = create(3412, res)

const a6, l6, d6, dp6, m6, c6 = limscoef(x6, y6, len, numitr, 1e5, -8, 8)

plot3notitle(a4, l4, l5, l6, "Documents/GitHub/497R-Projects/Figure4.png", "Lift Coefficient")

plot3coefficients(a4, d4, "NACA 1412", d5, "NACA 2412", d6, "NACA 3412", "Documents/GitHub/497R-Projects/Figure5.png", "Drag Coefficient")

plot3notitle(a4, m4, m5, m6, "Documents/GitHub/497R-Projects/Figure6.png", "Moment Coefficient")

#=---------------------------------------------------------------
This section explores the effects of different Reynolds numbers
on airfoil performance.
---------------------------------------------------------------=#

const x7, y7 = create(2209, res)

const a7a, l7a, d7a, dp7a, m7a, c7a = limscoef(x7, y7, len, numitr, 1e5, -8, 8)

const a7b, l7b, d7b, dp7b, m7b, c7b = limscoef(x7, y7, len, numitr, 2e5, -8, 8)

const a7c, l7c, d7c, dp7c, m7c, c7c = limscoef(x7, y7, len, numitr, 3e5, -8, 8)

plot3notitle(a7a, l7a,l7b, l7c, "Documents/GitHub/497R-Projects/Figure7.png", "Lift Coefficient")

plot3coefficients(a7a, d7a, "Re = 100,000", d7b, "Re = 200,000", d7c, "Re = 300,000", "Documents/GitHub/497R-Projects/Figure8.png", "Drag Coefficient")

plot3notitle(a7a, m7a, m7b, m7c, "Documents/GitHub/497R-Projects/Figure9.png", "Moment Coefficient")

const x8, y8 = create(1115, res)

const a8a, l8a, d8a, dp8a, m8a, c7a = limscoef(x8, y8, len, numitr, 1e5, -8, 8)

const a8b, l8b, d8b, dp8b, m8b, c7b = limscoef(x8, y8, len, numitr, 2e5, -8, 8)

const a8c, l8c, d8c, dp8c, m8c, c7c = limscoef(x8, y8, len, numitr, 3e5, -8, 8)

plot3notitle(a8a, l8a, l8b, l8c, "Documents/GitHub/497R-Projects/Figure10.png", "Lift Coefficient")

plot3coefficients(a8a, d8a, "Re = 100,000", d8b, "Re = 200,000", d8c, "Re = 300,000", "Documents/GitHub/497R-Projects/Figure11.png", "Drag Coefficient")

plot3notitle(a8a, m8a, m8b, m8c, "Documents/GitHub/497R-Projects/Figure12.png", "Moment Coefficient")

#=---------------------------------------------------------------
This section examines different airfoil thicknesses and cambers.
---------------------------------------------------------------=#

const x9, y9 = create(2208, res)

const a9, l9, d9, dp9, m9, c9 = limscoef(x9, y9, len, numitr, 1e5, -8, 8)

const x10, y10 = create(2213, res)

const a10, l10, d10, dp10, m10, c10 = limscoef(x10, y10, len, numitr, 1e5, -8, 8)

const x11, y11 = create(2218, res)

const a11, l11, d11, dp11, m11, c11 = limscoef(x11, y11, len, numitr, 1e5, -8, 8)

plot3notitle(a9, l9, l10, l11, "Documents/GitHub/497R-Projects/Figure13.png", "Lift Coefficient")

plot3coefficients(a9, d9, "NACA 2208", d10, "NACA 2213", d11, "NACA 2218", "Documents/GitHub/497R-Projects/Figure14.png", "Drag Coefficient")

plot3notitle(a9, m9, m10, m11, "Documents/GitHub/497R-Projects/Figure15.png", "Moment Coefficient")

const x12, y12 = create(2114, res)

const a12, l12, d12, dp12, m12, c12 = limscoef(x12, y12, len, numitr, 1e5, -8, 8)

const x13, y13 = create(2214, res)

const a13, l13, d13, dp13, m13, c13 = limscoef(x13, y13, len, numitr, 1e5, -8, 8)

const x14, y14 = create(2314, res)

const a14, l14, d14, dp14, m14, c14 = limscoef(x14, y14, len, numitr, 1e5, -8, 8)

plot3notitle(a12, l12, l13, l14, "Documents/GitHub/497R-Projects/Figure16.png", "Lift Coefficient")

plot3coefficients(a12, d12, "NACA 2114", d13, "NACA 2214", d14, "NACA 2314", "Documents/GitHub/497R-Projects/Figure17.png", "Drag Coefficient")

plot3notitle(a12, m12, m13, m14, "Documents/GitHub/497R-Projects/Figure18.png", "Moment Coefficient")

const α14 = findα0(a14, l14)

const sl14 = findslope(a14, l14, α14)

const st14 = findstall(x14, y14, α14, sl14, 50, 1e5)

plotliftdrag(l14, d14, "Documents/GitHub/497R-Projects/Figure19.png")

polar("lift", x7, y7, 1.0, 10000, 150000, numitr, "Reynolds Number", "Lift Coefficient", "Documents/GitHub/497R-Projects/Figure20.png")

polar("drag", x7, y7, 1.0, 10000, 150000, numitr, "Reynolds Number", "Drag Coefficient", "Documents/GitHub/497R-Projects/Figure21.png")

polar("moment", x7, y7, 1.0, 10000, 150000, numitr, "Reynolds Number", "Moment Coefficient", "Documents/GitHub/497R-Projects/Figure22.png")

α7a = findα0(a7a, l7a)

α7b = findα0(a7b, l7b)

α7c = findα0(a7c, l7c)

plotliftdrag(l9, d10, "Documents/GitHub/497R-Projects/Figure23.png")

plotliftdrag(l10, d11, "Documents/GitHub/497R-Projects/Figure24.png")

plotliftdrag(l11, d12, "Documents/GitHub/497R-Projects/Figure25.png")