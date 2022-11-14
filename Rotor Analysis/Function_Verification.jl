#=---------------------------------------------------------------
10/17/2022
Function Verification v1 Function_Verification.jl
This code was used to verify the unexpected results from
Rotor_Analysis.jl. After discussing with Adam, I was able to
understand why the efficiency did not go below zero.
---------------------------------------------------------------=#
using CCBlade
Rtip = 10/2.0 * 0.0254  # inches to meters
Rhub = 0.10*Rtip
B = 2  # number of blades
rotor = Rotor(Rhub, Rtip, B)
propgeom = [
    0.15   0.109   34.86
    0.20   0.132   37.60
    0.25   0.155   36.15
    0.30   0.175   33.87
    0.35   0.192   31.25
    0.40   0.206   28.48
    0.45   0.216   25.60
    0.50   0.222   22.79
    0.55   0.225   20.49
    0.60   0.224   18.70
    0.65   0.219   17.14
    0.70   0.210   15.64
    0.75   0.197   14.38
    0.80   0.180   13.11
    0.85   0.159   11.83
    0.90   0.133   10.65
    0.95   0.092   9.53
    1.00   0.049   8.43
]
r = propgeom[:, 1] * Rtip
chord = propgeom[:, 2] * Rtip
theta = propgeom[:, 3] * pi/180
af = AlphaAF("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Rotors/naca4412.dat")
sections = Section.(r, chord, theta, Ref(af))
Vinf = 5.0
Omega = 6014*pi/30  # convert to rad/s
rho = 1.225
op = simple_op.(Vinf, Omega, r, rho)
out = solve.(Ref(rotor), sections, op)
exp1 = [
    0.408	0.1074	0.0708	0.619
    0.429	0.1032	0.0693	0.639
    0.452	0.0988	0.0678	0.658
    0.478	0.0928	0.0653	0.679
    0.500	0.0886	0.0638	0.695
    0.523	0.0847	0.0624	0.709
    0.550	0.0791	0.0602	0.722
    0.572	0.0755	0.0589	0.733
    0.594	0.0707	0.0568	0.740
    0.624	0.0643	0.0539	0.744
    0.646	0.0602	0.0520	0.748
    0.666	0.0554	0.0498	0.742
    0.697	0.0479	0.0460	0.726
    0.713	0.0438	0.0440	0.710
    0.738	0.0377	0.0409	0.679
    0.767	0.0302	0.0373	0.622
    0.787	0.0247	0.0344	0.564
    0.807	0.0184	0.0311	0.478
    0.841	0.0092	0.0262	0.297
    0.857	0.0048	0.0239	0.172
    0.886	-0.0034	0.0195	-0.153
    0.910	-0.0105	0.0156	-0.613
    0.935	-0.0178	0.0116	-1.441
    0.959	-0.0247	0.0078	-3.029
]
Jexp = exp1[:, 1]
CTexp = exp1[:, 2]
CPexp = exp1[:, 3]
etaexp = exp1[:, 4]
nJ = 24  # number of advance ratios
J = Jexp
Omega = 6014.0*pi/30
n = Omega/(2*pi)
D = 2*Rtip
eff = zeros(nJ)
CT = zeros(nJ)
CQ = zeros(nJ)
for i = 1:nJ
    local Vinf = J[i] * D * n
    local op = simple_op.(Vinf, Omega, r, rho)
    outputs = solve.(Ref(rotor), sections, op)
    T, Q = thrusttorque(rotor, sections, outputs)
    eff[i], CT[i], CQ[i] = nondim(T, Q, Vinf, Omega, rho, rotor, "propeller")
end
plt = scatter(Jexp, eff, label = "predicted", xlabel = "J", ylabel = "\\eta", tickfontsize = 12, xguidefontsize = 18, yguidefontsize = 18, legendfontsize = 20, background_color_legend = nothing, legend = :bottomleft)
scatter!(Jexp, etaexp, markershape = :square, label = "experimental")
display(plt)