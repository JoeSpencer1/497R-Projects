#=---------------------------------------------------------------
10/3/2022
Guided Example v1 Guided_Example.jl
This tutorial gave more examples and guidance to develop my own
rotor analysis code using CCBlade and FLOWMath and use it to
analyze an airfoil.
---------------------------------------------------------------=#
using CCBlade, Plots

xfoildata = [
 -14.000  -1.0990   0.02637   0.02282  -0.0871   0.9992   0.0166
 -13.750  -1.0711   0.02533   0.02165  -0.0885   0.9979   0.0170
 -13.500  -1.0462   0.02365   0.01985  -0.0903   0.9963   0.0177
 -13.250  -1.0163   0.02288   0.01905  -0.0918   0.9951   0.0183
 -13.000  -0.9847   0.02237   0.01850  -0.0933   0.9943   0.0189
 -12.750  -0.9549   0.02183   0.01790  -0.0943   0.9930   0.0195
 -12.500  -0.9260   0.02126   0.01724  -0.0952   0.9911   0.0201
 -12.250  -0.8954   0.02078   0.01666  -0.0963   0.9894   0.0206
 -12.000  -0.8682   0.01946   0.01525  -0.0976   0.9877   0.0214
 -11.750  -0.8365   0.01894   0.01471  -0.0990   0.9866   0.0220
 -11.500  -0.8038   0.01852   0.01424  -0.1004   0.9857   0.0227
 -11.250  -0.7707   0.01808   0.01375  -0.1019   0.9849   0.0235
 -11.000  -0.7369   0.01769   0.01328  -0.1035   0.9843   0.0242
 -10.750  -0.7070   0.01745   0.01297  -0.1041   0.9819   0.0246
 -10.500  -0.6803   0.01619   0.01161  -0.1049   0.9793   0.0257
 -10.250  -0.6491   0.01569   0.01109  -0.1060   0.9775   0.0264
 -10.000  -0.6172   0.01529   0.01065  -0.1071   0.9759   0.0271
  -9.750  -0.5850   0.01491   0.01022  -0.1082   0.9742   0.0279
  -9.500  -0.5547   0.01456   0.00981  -0.1089   0.9718   0.0287
  -9.250  -0.5287   0.01426   0.00944  -0.1085   0.9665   0.0292
  -9.000  -0.5023   0.01345   0.00855  -0.1085   0.9622   0.0299
  -8.750  -0.4769   0.01285   0.00791  -0.1082   0.9574   0.0309
  -8.500  -0.4513   0.01249   0.00752  -0.1078   0.9519   0.0317
  -8.250  -0.4243   0.01214   0.00713  -0.1076   0.9474   0.0324
  -8.000  -0.3979   0.01184   0.00678  -0.1073   0.9422   0.0333
  -7.750  -0.3715   0.01155   0.00644  -0.1070   0.9363   0.0340
  -7.500  -0.3442   0.01127   0.00609  -0.1068   0.9313   0.0345
  -7.250  -0.3183   0.01080   0.00556  -0.1064   0.9249   0.0354
  -7.000  -0.2921   0.01033   0.00505  -0.1061   0.9186   0.0365
  -6.750  -0.2649   0.01003   0.00471  -0.1059   0.9125   0.0375
  -6.500  -0.2377   0.00977   0.00441  -0.1057   0.9053   0.0384
  -6.000  -0.1825   0.00935   0.00389  -0.1054   0.8910   0.0404
  -5.750  -0.1549   0.00912   0.00360  -0.1052   0.8835   0.0414
  -5.500  -0.1275   0.00880   0.00325  -0.1051   0.8751   0.0435
  -5.000  -0.0718   0.00845   0.00283  -0.1049   0.8578   0.0476
  -4.750  -0.0441   0.00824   0.00259  -0.1047   0.8488   0.0519
  -4.500  -0.0162   0.00810   0.00243  -0.1046   0.8388   0.0569
  -4.250   0.0117   0.00793   0.00228  -0.1045   0.8288   0.0655
  -4.000   0.0394   0.00780   0.00213  -0.1044   0.8184   0.0745
  -3.750   0.0674   0.00769   0.00201  -0.1044   0.8073   0.0820
  -3.500   0.0954   0.00761   0.00191  -0.1043   0.7964   0.0890
  -3.250   0.1232   0.00752   0.00180  -0.1042   0.7851   0.0977
  -3.000   0.1512   0.00745   0.00171  -0.1041   0.7733   0.1066
  -2.750   0.1791   0.00737   0.00163  -0.1040   0.7616   0.1182
  -2.500   0.2069   0.00729   0.00156  -0.1040   0.7497   0.1332
  -2.250   0.2346   0.00723   0.00150  -0.1039   0.7378   0.1502
  -2.000   0.2625   0.00715   0.00145  -0.1038   0.7254   0.1697
  -1.750   0.2903   0.00709   0.00142  -0.1038   0.7132   0.1927
  -1.500   0.3180   0.00703   0.00141  -0.1037   0.7012   0.2214
  -1.250   0.3456   0.00701   0.00139  -0.1036   0.6886   0.2466
  -1.000   0.3734   0.00697   0.00138  -0.1035   0.6754   0.2686
  -0.750   0.4012   0.00694   0.00137  -0.1035   0.6626   0.2903
  -0.500   0.4288   0.00691   0.00138  -0.1034   0.6497   0.3203
  -0.250   0.4562   0.00686   0.00139  -0.1033   0.6365   0.3629
   0.000   0.4833   0.00678   0.00141  -0.1032   0.6232   0.4192
   0.250   0.5102   0.00658   0.00146  -0.1031   0.6101   0.5177
   0.500   0.5366   0.00635   0.00153  -0.1029   0.5975   0.6393
   0.750   0.5622   0.00617   0.00160  -0.1024   0.5856   0.7449
   1.000   0.5842   0.00594   0.00170  -0.1009   0.5740   0.8717
   1.250   0.6163   0.00588   0.00177  -0.1014   0.5622   0.9842
   1.500   0.6525   0.00598   0.00181  -0.1033   0.5505   1.0000
   1.750   0.6788   0.00611   0.00186  -0.1029   0.5398   1.0000
   2.000   0.7055   0.00622   0.00192  -0.1026   0.5294   1.0000
   2.250   0.7325   0.00633   0.00199  -0.1024   0.5204   1.0000
   2.500   0.7592   0.00646   0.00206  -0.1022   0.5112   1.0000
   2.750   0.7865   0.00656   0.00213  -0.1020   0.5029   1.0000
   3.250   0.8405   0.00681   0.00231  -0.1016   0.4847   1.0000
   3.500   0.8672   0.00696   0.00240  -0.1014   0.4746   1.0000
   3.750   0.8941   0.00709   0.00250  -0.1012   0.4646   1.0000
   4.000   0.9210   0.00722   0.00260  -0.1010   0.4540   1.0000
   4.250   0.9473   0.00739   0.00272  -0.1007   0.4426   1.0000
   4.500   0.9734   0.00758   0.00284  -0.1004   0.4273   1.0000
   4.750   0.9993   0.00778   0.00297  -0.1001   0.4110   1.0000
   5.000   1.0254   0.00797   0.00311  -0.0998   0.3979   1.0000
   5.250   1.0518   0.00813   0.00326  -0.0995   0.3861   1.0000
   5.500   1.0777   0.00834   0.00342  -0.0992   0.3731   1.0000
   5.750   1.1031   0.00857   0.00359  -0.0988   0.3575   1.0000
   6.000   1.1280   0.00884   0.00379  -0.0983   0.3398   1.0000
   6.250   1.1523   0.00914   0.00401  -0.0978   0.3207   1.0000
   6.500   1.1761   0.00948   0.00426  -0.0971   0.2993   1.0000
   6.750   1.1988   0.00989   0.00455  -0.0963   0.2737   1.0000
   7.000   1.2208   0.01036   0.00488  -0.0954   0.2461   1.0000
   7.250   1.2417   0.01089   0.00526  -0.0943   0.2173   1.0000
   7.500   1.2614   0.01149   0.00569  -0.0931   0.1865   1.0000
   7.750   1.2793   0.01220   0.00621  -0.0915   0.1526   1.0000
   8.000   1.2973   0.01288   0.00672  -0.0900   0.1252   1.0000
   8.250   1.3164   0.01345   0.00719  -0.0887   0.1065   1.0000
   8.500   1.3346   0.01404   0.00769  -0.0872   0.0893   1.0000
   8.750   1.3514   0.01469   0.00823  -0.0854   0.0729   1.0000
   9.000   1.3676   0.01527   0.00875  -0.0836   0.0622   1.0000
   9.250   1.3835   0.01581   0.00926  -0.0817   0.0563   1.0000
   9.500   1.4004   0.01631   0.00976  -0.0799   0.0521   1.0000
   9.750   1.4171   0.01682   0.01028  -0.0782   0.0491   1.0000
  10.000   1.4317   0.01746   0.01091  -0.0762   0.0459   1.0000
  10.250   1.4484   0.01797   0.01147  -0.0746   0.0442   1.0000
  10.500   1.4653   0.01849   0.01203  -0.0731   0.0427   1.0000
  10.750   1.4805   0.01911   0.01267  -0.0714   0.0411   1.0000
  11.000   1.4938   0.01986   0.01343  -0.0695   0.0392   1.0000
  11.250   1.5061   0.02069   0.01430  -0.0676   0.0376   1.0000
  11.500   1.5221   0.02129   0.01495  -0.0662   0.0368   1.0000
  11.750   1.5369   0.02199   0.01570  -0.0647   0.0356   1.0000
  12.000   1.5500   0.02282   0.01656  -0.0631   0.0343   1.0000
  12.250   1.5608   0.02382   0.01758  -0.0614   0.0330   1.0000
  12.500   1.5688   0.02506   0.01888  -0.0594   0.0316   1.0000
  12.750   1.5831   0.02588   0.01975  -0.0582   0.0308   1.0000
  13.000   1.5959   0.02683   0.02075  -0.0569   0.0298   1.0000
  13.250   1.6066   0.02796   0.02192  -0.0555   0.0286   1.0000
  13.500   1.6141   0.02939   0.02338  -0.0540   0.0273   1.0000
  13.750   1.6213   0.03089   0.02494  -0.0526   0.0262   1.0000
  14.000   1.6325   0.03209   0.02620  -0.0516   0.0252   1.0000
  14.250   1.6414   0.03354   0.02770  -0.0505   0.0241   1.0000
  14.500   1.6474   0.03528   0.02947  -0.0493   0.0229   1.0000
  14.750   1.6508   0.03731   0.03156  -0.0482   0.0218   1.0000
  15.000   1.6585   0.03899   0.03332  -0.0474   0.0209   1.0000
  15.250   1.6638   0.04096   0.03533  -0.0466   0.0198   1.0000
  15.500   1.6661   0.04330   0.03772  -0.0458   0.0187   1.0000
  15.750   1.6666   0.04589   0.04037  -0.0451   0.0179   1.0000
  16.000   1.6698   0.04827   0.04284  -0.0447   0.0171   1.0000
  16.250   1.6706   0.05099   0.04562  -0.0443   0.0164   1.0000
  16.500   1.6692   0.05402   0.04871  -0.0440   0.0157   1.0000
  16.750   1.6638   0.05759   0.05235  -0.0439   0.0151   1.0000
  17.000   1.6605   0.06101   0.05587  -0.0439   0.0146   1.0000
  17.250   1.6584   0.06435   0.05931  -0.0441   0.0142   1.0000
  17.500   1.6548   0.06793   0.06298  -0.0444   0.0138   1.0000
  17.750   1.6497   0.07175   0.06689  -0.0448   0.0134   1.0000
  18.000   1.6430   0.07583   0.07106  -0.0453   0.0131   1.0000
  18.250   1.6346   0.08024   0.07555  -0.0461   0.0128   1.0000
  18.500   1.6237   0.08507   0.08047  -0.0470   0.0124   1.0000
  18.750   1.6097   0.09040   0.08590  -0.0482   0.0121   1.0000
]

alpha_0 = xfoildata[:, 1] * pi/180
cl_0 = xfoildata[:, 2]
cd_0 = xfoildata[:, 3]

plot(alpha_0, cl_0, xlabel = "\\alpha", ylabel = "c_l")

plot(alpha_0, cd_0, xlabel = "\\alpha", ylabel = "c_d")

cr75 = 0.128
alpha_ext, cl_ext, cd_ext = viterna(alpha_0, cl_0, cd_0, cr75)

plot(alpha_ext, cl_ext, xlabel = "\\alpha", ylabel = "c_l")

plot(alpha_ext, cd_ext, xlabel = "\\alpha", ylabel = "c_d")

alpha3, cl3, cd3 = alpha_ext, cl_ext, cd_ext

xfoildata2 = [
 -12.250  -0.8284   0.04176   0.03861  -0.0832   1.0000   0.0246
 -12.000  -0.8522   0.03908   0.03574  -0.0799   1.0000   0.0247
 -11.750  -0.8699   0.03540   0.03185  -0.0776   0.9997   0.0251
 -11.500  -0.8415   0.03435   0.03082  -0.0796   0.9977   0.0258
 -11.250  -0.8114   0.03347   0.02989  -0.0818   0.9957   0.0265
 -11.000  -0.7822   0.03202   0.02830  -0.0843   0.9939   0.0275
 -10.750  -0.7591   0.02982   0.02579  -0.0862   0.9905   0.0285
 -10.500  -0.7309   0.02822   0.02384  -0.0882   0.9877   0.0293
 -10.250  -0.7053   0.02556   0.02100  -0.0903   0.9856   0.0304
 -10.000  -0.6714   0.02497   0.02039  -0.0924   0.9843   0.0314
  -9.750  -0.6435   0.02420   0.01952  -0.0932   0.9807   0.0325
  -9.500  -0.6134   0.02311   0.01823  -0.0945   0.9778   0.0336
  -9.250  -0.5802   0.02227   0.01716  -0.0962   0.9758   0.0345
  -9.000  -0.5492   0.02031   0.01504  -0.0982   0.9742   0.0359
  -8.750  -0.5132   0.01962   0.01432  -0.1004   0.9731   0.0371
  -8.500  -0.4849   0.01894   0.01355  -0.1008   0.9683   0.0381
  -8.250  -0.4502   0.01823   0.01273  -0.1025   0.9656   0.0394
  -8.000  -0.4135   0.01756   0.01192  -0.1045   0.9637   0.0405
  -7.750  -0.3794   0.01639   0.01059  -0.1062   0.9619   0.0416
  -7.500  -0.3455   0.01547   0.00965  -0.1078   0.9602   0.0430
  -7.250  -0.3201   0.01501   0.00917  -0.1073   0.9539   0.0442
  -7.000  -0.2893   0.01445   0.00854  -0.1080   0.9502   0.0454
  -6.750  -0.2573   0.01389   0.00791  -0.1088   0.9471   0.0467
  -6.500  -0.2303   0.01351   0.00746  -0.1085   0.9415   0.0478
  -6.250  -0.2035   0.01278   0.00668  -0.1083   0.9357   0.0494
  -6.000  -0.1743   0.01225   0.00613  -0.1085   0.9314   0.0512
  -5.750  -0.1485   0.01190   0.00577  -0.1080   0.9242   0.0529
  -5.500  -0.1206   0.01155   0.00536  -0.1078   0.9180   0.0550
  -5.250  -0.0931   0.01118   0.00493  -0.1076   0.9117   0.0575
  -5.000  -0.0666   0.01079   0.00457  -0.1072   0.9038   0.0614
  -4.750  -0.0382   0.01055   0.00427  -0.1071   0.8974   0.0656
  -4.500  -0.0118   0.01018   0.00393  -0.1067   0.8884   0.0727
  -4.250   0.0161   0.00990   0.00363  -0.1066   0.8810   0.0812
  -4.000   0.0434   0.00973   0.00343  -0.1063   0.8716   0.0897
  -3.750   0.0710   0.00948   0.00321  -0.1061   0.8628   0.1006
  -3.500   0.0987   0.00929   0.00301  -0.1060   0.8534   0.1110
  -3.250   0.1262   0.00913   0.00285  -0.1058   0.8432   0.1221
  -3.000   0.1541   0.00898   0.00269  -0.1056   0.8335   0.1353
  -2.750   0.1815   0.00882   0.00255  -0.1054   0.8224   0.1520
  -2.500   0.2090   0.00867   0.00244  -0.1053   0.8113   0.1733
  -2.250   0.2366   0.00855   0.00235  -0.1051   0.8004   0.1993
  -2.000   0.2641   0.00844   0.00229  -0.1049   0.7887   0.2300
  -1.750   0.2915   0.00833   0.00224  -0.1048   0.7765   0.2579
  -1.500   0.3190   0.00826   0.00218  -0.1046   0.7645   0.2832
  -1.250   0.3463   0.00818   0.00213  -0.1044   0.7525   0.3117
  -1.000   0.3734   0.00807   0.00209  -0.1042   0.7397   0.3503
  -0.750   0.4003   0.00792   0.00208  -0.1040   0.7267   0.4055
  -0.500   0.4265   0.00766   0.00208  -0.1038   0.7141   0.5024
  -0.250   0.4513   0.00733   0.00214  -0.1031   0.7014   0.6445
   0.000   0.4741   0.00703   0.00220  -0.1018   0.6886   0.7752
   0.250   0.4944   0.00681   0.00229  -0.0995   0.6757   0.9086
   0.500   0.5429   0.00683   0.00228  -0.1037   0.6616   0.9948
   0.750   0.5727   0.00693   0.00228  -0.1041   0.6484   1.0000
   1.000   0.5983   0.00705   0.00231  -0.1035   0.6356   1.0000
   1.250   0.6239   0.00719   0.00235  -0.1030   0.6230   1.0000
   1.500   0.6499   0.00731   0.00240  -0.1026   0.6104   1.0000
   1.750   0.6761   0.00744   0.00246  -0.1022   0.5984   1.0000
   2.000   0.7023   0.00759   0.00253  -0.1018   0.5871   1.0000
   2.250   0.7283   0.00775   0.00260  -0.1014   0.5758   1.0000
   2.500   0.7548   0.00788   0.00269  -0.1011   0.5646   1.0000
   2.750   0.7811   0.00804   0.00279  -0.1007   0.5544   1.0000
   3.000   0.8073   0.00820   0.00290  -0.1004   0.5444   1.0000
   3.250   0.8339   0.00834   0.00302  -0.1001   0.5349   1.0000
   3.500   0.8600   0.00854   0.00314  -0.0998   0.5260   1.0000
   3.750   0.8867   0.00866   0.00327  -0.0995   0.5166   1.0000
   4.000   0.9127   0.00884   0.00341  -0.0992   0.5067   1.0000
   4.250   0.9385   0.00902   0.00355  -0.0988   0.4957   1.0000
   4.500   0.9647   0.00917   0.00370  -0.0984   0.4849   1.0000
   4.750   0.9903   0.00937   0.00385  -0.0980   0.4741   1.0000
   5.000   1.0155   0.00957   0.00400  -0.0975   0.4618   1.0000
   5.250   1.0403   0.00977   0.00416  -0.0970   0.4460   1.0000
   5.500   1.0652   0.00997   0.00433  -0.0964   0.4309   1.0000
   5.750   1.0906   0.01016   0.00452  -0.0960   0.4187   1.0000
   6.000   1.1155   0.01038   0.00472  -0.0955   0.4067   1.0000
   6.250   1.1399   0.01063   0.00495  -0.0949   0.3935   1.0000
   6.500   1.1639   0.01090   0.00518  -0.0942   0.3784   1.0000
   6.750   1.1875   0.01119   0.00543  -0.0935   0.3609   1.0000
   7.000   1.2103   0.01152   0.00571  -0.0927   0.3410   1.0000
   7.250   1.2318   0.01193   0.00603  -0.0917   0.3191   1.0000
   7.500   1.2528   0.01238   0.00639  -0.0906   0.2935   1.0000
   7.750   1.2718   0.01294   0.00682  -0.0892   0.2643   1.0000
   8.000   1.2891   0.01362   0.00734  -0.0876   0.2320   1.0000
   8.250   1.3042   0.01442   0.00794  -0.0856   0.1973   1.0000
   8.500   1.3175   0.01531   0.00862  -0.0834   0.1607   1.0000
   8.750   1.3282   0.01622   0.00934  -0.0807   0.1301   1.0000
   9.000   1.3388   0.01711   0.01011  -0.0781   0.1080   1.0000
   9.250   1.3500   0.01798   0.01089  -0.0756   0.0904   1.0000
   9.500   1.3615   0.01884   0.01169  -0.0732   0.0782   1.0000
   9.750   1.3735   0.01968   0.01251  -0.0709   0.0704   1.0000
  10.000   1.3845   0.02060   0.01340  -0.0687   0.0648   1.0000
  10.250   1.3969   0.02144   0.01429  -0.0667   0.0610   1.0000
  10.500   1.4094   0.02230   0.01519  -0.0648   0.0580   1.0000
  10.750   1.4184   0.02340   0.01630  -0.0626   0.0550   1.0000
  11.000   1.4270   0.02457   0.01753  -0.0605   0.0528   1.0000
  11.250   1.4395   0.02551   0.01855  -0.0589   0.0510   1.0000
  11.500   1.4503   0.02659   0.01969  -0.0573   0.0492   1.0000
  11.750   1.4584   0.02791   0.02104  -0.0555   0.0473   1.0000
  12.000   1.4602   0.02976   0.02294  -0.0533   0.0455   1.0000
  12.250   1.4688   0.03116   0.02443  -0.0519   0.0443   1.0000
  12.500   1.4791   0.03246   0.02581  -0.0507   0.0429   1.0000
  12.750   1.4875   0.03395   0.02738  -0.0495   0.0414   1.0000
  13.000   1.4938   0.03568   0.02917  -0.0483   0.0400   1.0000
  13.250   1.4941   0.03801   0.03154  -0.0469   0.0387   1.0000
  13.500   1.4941   0.04045   0.03407  -0.0457   0.0375   1.0000
  13.750   1.5030   0.04212   0.03584  -0.0450   0.0363   1.0000
  14.000   1.5091   0.04410   0.03790  -0.0444   0.0349   1.0000
  14.250   1.5135   0.04630   0.04017  -0.0438   0.0337   1.0000
  14.500   1.5126   0.04913   0.04305  -0.0432   0.0326   1.0000
  14.750   1.5064   0.05260   0.04659  -0.0426   0.0315   1.0000
  15.000   1.5124   0.05486   0.04898  -0.0424   0.0305   1.0000
  15.250   1.5153   0.05748   0.05169  -0.0423   0.0294   1.0000
  15.500   1.5171   0.06031   0.05459  -0.0423   0.0283   1.0000
  15.750   1.5155   0.06359   0.05793  -0.0425   0.0274   1.0000
  16.000   1.5055   0.06789   0.06228  -0.0426   0.0265   1.0000
  16.250   1.5080   0.07082   0.06534  -0.0429   0.0257   1.0000
  16.500   1.5081   0.07407   0.06871  -0.0433   0.0248   1.0000
  16.750   1.5068   0.07756   0.07229  -0.0439   0.0240   1.0000
  17.000   1.5043   0.08125   0.07605  -0.0445   0.0233   1.0000
  17.250   1.4987   0.08538   0.08024  -0.0453   0.0226   1.0000
]

alpha = xfoildata2[:, 1] * pi/180
cl = xfoildata2[:, 2]
cd = xfoildata2[:, 3]

alpha2, cl2, cd2 = viterna(alpha, cl, cd, cr75)

xfoildata1 = [
  -8.500  -0.4088   0.08983   0.08647  -0.0344   1.0000   0.0813
  -8.250  -0.4231   0.08831   0.08501  -0.0315   1.0000   0.0823
  -8.000  -0.4442   0.08695   0.08373  -0.0282   1.0000   0.0831
  -7.750  -0.4937   0.05313   0.04929  -0.0671   0.9865   0.0673
  -7.500  -0.4712   0.04655   0.04243  -0.0720   0.9817   0.0641
  -7.250  -0.4535   0.03731   0.03244  -0.0777   0.9755   0.0622
  -7.000  -0.4231   0.03226   0.02667  -0.0816   0.9717   0.0637
  -6.750  -0.3952   0.02910   0.02295  -0.0831   0.9655   0.0647
  -6.500  -0.3582   0.02703   0.02031  -0.0857   0.9620   0.0660
  -6.250  -0.3204   0.02462   0.01772  -0.0887   0.9600   0.0684
  -6.000  -0.2930   0.02357   0.01656  -0.0890   0.9523   0.0702
  -5.750  -0.2544   0.02238   0.01517  -0.0913   0.9489   0.0725
  -5.500  -0.2129   0.02134   0.01390  -0.0940   0.9465   0.0756
  -5.250  -0.1843   0.02032   0.01270  -0.0942   0.9393   0.0785
  -5.000  -0.1466   0.01934   0.01174  -0.0963   0.9352   0.0824
  -4.750  -0.1047   0.01855   0.01086  -0.0990   0.9326   0.0877
  -4.500  -0.0618   0.01758   0.00989  -0.1020   0.9308   0.0951
  -4.250  -0.0351   0.01719   0.00943  -0.1016   0.9217   0.1030
  -4.000   0.0030   0.01638   0.00871  -0.1036   0.9180   0.1150
  -3.750   0.0426   0.01571   0.00806  -0.1058   0.9151   0.1299
  -3.500   0.0687   0.01531   0.00771  -0.1053   0.9057   0.1437
  -3.250   0.1047   0.01477   0.00720  -0.1066   0.9011   0.1620
  -3.000   0.1342   0.01437   0.00686  -0.1068   0.8934   0.1821
  -2.750   0.1659   0.01392   0.00653  -0.1073   0.8865   0.2077
  -2.500   0.1964   0.01352   0.00623  -0.1075   0.8792   0.2377
  -2.250   0.2255   0.01312   0.00593  -0.1075   0.8706   0.2707
  -2.000   0.2541   0.01274   0.00566  -0.1074   0.8618   0.3065
  -1.750   0.2836   0.01233   0.00537  -0.1074   0.8533   0.3489
  -1.500   0.3098   0.01195   0.00520  -0.1069   0.8424   0.4005
  -1.250   0.3373   0.01136   0.00499  -0.1066   0.8336   0.5000
  -1.000   0.3583   0.01070   0.00498  -0.1046   0.8222   0.6832
  -0.500   0.4431   0.00999   0.00468  -0.1085   0.8021   1.0000
  -0.250   0.4683   0.01000   0.00456  -0.1077   0.7890   1.0000
   0.000   0.4938   0.01005   0.00448  -0.1071   0.7758   1.0000
   0.250   0.5198   0.01011   0.00441  -0.1065   0.7629   1.0000
   0.500   0.5464   0.01019   0.00435  -0.1060   0.7504   1.0000
   0.750   0.5733   0.01027   0.00429  -0.1056   0.7383   1.0000
   1.000   0.5988   0.01039   0.00431  -0.1050   0.7246   1.0000
   1.250   0.6247   0.01052   0.00435  -0.1045   0.7115   1.0000
   1.500   0.6510   0.01066   0.00439  -0.1040   0.6992   1.0000
   1.750   0.6778   0.01082   0.00443  -0.1036   0.6876   1.0000
   2.000   0.7038   0.01097   0.00451  -0.1032   0.6752   1.0000
   2.250   0.7297   0.01115   0.00463  -0.1027   0.6629   1.0000
   2.500   0.7561   0.01133   0.00474  -0.1023   0.6517   1.0000
   2.750   0.7828   0.01152   0.00483  -0.1020   0.6409   1.0000
   3.000   0.8084   0.01171   0.00500  -0.1014   0.6289   1.0000
   3.250   0.8345   0.01191   0.00515  -0.1010   0.6180   1.0000
   3.500   0.8613   0.01213   0.00528  -0.1007   0.6079   1.0000
   3.750   0.8865   0.01233   0.00549  -0.1002   0.5965   1.0000
   4.000   0.9127   0.01256   0.00569  -0.0998   0.5863   1.0000
   4.250   0.9390   0.01280   0.00587  -0.0995   0.5765   1.0000
   4.500   0.9643   0.01303   0.00613  -0.0990   0.5659   1.0000
   4.750   0.9905   0.01330   0.00636  -0.0986   0.5563   1.0000
   5.000   1.0156   0.01352   0.00657  -0.0980   0.5448   1.0000
   5.250   1.0396   0.01373   0.00679  -0.0972   0.5317   1.0000
   5.500   1.0639   0.01396   0.00701  -0.0965   0.5191   1.0000
   5.750   1.0888   0.01422   0.00724  -0.0959   0.5080   1.0000
   6.000   1.1122   0.01444   0.00743  -0.0950   0.4940   1.0000
   6.250   1.1342   0.01464   0.00764  -0.0938   0.4781   1.0000
   6.500   1.1562   0.01486   0.00788  -0.0927   0.4627   1.0000
   6.750   1.1783   0.01510   0.00815  -0.0916   0.4482   1.0000
   7.000   1.2002   0.01536   0.00845  -0.0905   0.4333   1.0000
   7.250   1.2215   0.01565   0.00876  -0.0893   0.4177   1.0000
   7.500   1.2420   0.01596   0.00908  -0.0880   0.4012   1.0000
   7.750   1.2616   0.01630   0.00943  -0.0866   0.3835   1.0000
   8.000   1.2799   0.01670   0.00982  -0.0849   0.3635   1.0000
   8.250   1.2967   0.01714   0.01026  -0.0831   0.3392   1.0000
   8.500   1.3110   0.01772   0.01076  -0.0809   0.3110   1.0000
   8.750   1.3218   0.01847   0.01138  -0.0781   0.2773   1.0000
   9.000   1.3267   0.01944   0.01217  -0.0745   0.2406   1.0000
   9.250   1.3283   0.02069   0.01320  -0.0706   0.1997   1.0000
   9.500   1.3275   0.02223   0.01449  -0.0667   0.1617   1.0000
   9.750   1.3266   0.02391   0.01597  -0.0630   0.1356   1.0000
  10.000   1.3275   0.02555   0.01752  -0.0598   0.1187   1.0000
  10.250   1.3289   0.02726   0.01916  -0.0569   0.1080   1.0000
  10.500   1.3326   0.02887   0.02077  -0.0544   0.1001   1.0000
  10.750   1.3366   0.03055   0.02249  -0.0520   0.0942   1.0000
  11.000   1.3429   0.03209   0.02408  -0.0501   0.0890   1.0000
  11.250   1.3438   0.03415   0.02607  -0.0479   0.0848   1.0000
  11.500   1.3530   0.03558   0.02764  -0.0464   0.0812   1.0000
  11.750   1.3601   0.03722   0.02934  -0.0450   0.0776   1.0000
  12.000   1.3641   0.03917   0.03125  -0.0433   0.0746   1.0000
  12.250   1.3713   0.04092   0.03309  -0.0418   0.0719   1.0000
  12.500   1.3790   0.04262   0.03491  -0.0407   0.0690   1.0000
  12.750   1.3857   0.04441   0.03676  -0.0395   0.0664   1.0000
  13.000   1.3923   0.04629   0.03859  -0.0382   0.0639   1.0000
  13.250   1.4001   0.04814   0.04054  -0.0369   0.0616   1.0000
  13.500   1.4059   0.05012   0.04268  -0.0360   0.0593   1.0000
  13.750   1.4115   0.05212   0.04477  -0.0351   0.0571   1.0000
  14.000   1.4180   0.05407   0.04670  -0.0342   0.0549   1.0000
  14.250   1.4266   0.05607   0.04875  -0.0329   0.0527   1.0000
  14.500   1.4286   0.05852   0.05141  -0.0322   0.0509   1.0000
  14.750   1.4308   0.06101   0.05404  -0.0316   0.0491   1.0000
  15.000   1.4342   0.06336   0.05644  -0.0312   0.0473   1.0000
  15.250   1.4467   0.06514   0.05814  -0.0297   0.0450   1.0000
  15.500   1.4416   0.06845   0.06172  -0.0297   0.0440   1.0000
  15.750   1.4385   0.07175   0.06524  -0.0296   0.0427   1.0000
  16.000   1.4362   0.07501   0.06865  -0.0296   0.0414   1.0000
  16.250   1.4351   0.07813   0.07188  -0.0298   0.0401   1.0000
  16.500   1.4392   0.08059   0.07434  -0.0296   0.0388   1.0000
  16.750   1.4401   0.08377   0.07759  -0.0291   0.0376   1.0000
  17.000   1.4274   0.08864   0.08274  -0.0304   0.0369   1.0000
  17.250   1.4151   0.09369   0.08804  -0.0318   0.0363   1.0000
]

alpha = xfoildata1[:, 1] * pi/180
cl = xfoildata1[:, 2]
cd = xfoildata1[:, 3]

alpha1, cl1, cd1 = viterna(alpha, cl, cd, cr75)

import FLOWMath

cl2 = FLOWMath.linear(alpha2, cl2, alpha1)
cd2 = FLOWMath.linear(alpha2, cd2, alpha1)
cl3 = FLOWMath.linear(alpha3, cl3, alpha1)
cd3 = FLOWMath.linear(alpha3, cd3, alpha1)

alpha = alpha1
Re = [2e5, 5e5, 1e6]
cl = [cl1 cl2 cl3]
cd = [cd1 cd2 cd3]

af = AlphaReAF(alpha, Re, cl, cd, "NACA4412 (no rotation)")

filenames = ["/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Airfoils/naca4412_2e5_norot.dat", "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Airfoils/naca4412_5e5_norot.dat", "/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Airfoils/naca4412_1e6_norot.dat"]
write_af(filenames, af)

af2 = AlphaReAF(filenames, radians=true)

Rtip = 10/2.0 * 0.0254
Rhub = 0.10*Rtip
B = 2
du = DuSeligEggers()
rotor = Rotor(Rhub, Rtip, B, rotation=du)

Rotor{Float64,Int64,Bool,Nothing,Nothing,DuSeligEggers{Float64},PrandtlTipHub}(0.012700000000000001, 0.127, 2, 0.0, false, nothing, nothing, DuSeligEggers{Float64}(1.0, 1.0, 1.0, 6.283185307179586, 0.0), PrandtlTipHub())

Re0 = 1e6
sf = TurbulentSkinFriction(Re0)

rotor = Rotor(Rhub, Rtip, B, rotation=du, re=sf)

Rotor{Float64,Int64,Bool,Nothing,SkinFriction{Float64},DuSeligEggers{Float64},PrandtlTipHub}(0.012700000000000001, 0.127, 2, 0.0, false, nothing, SkinFriction{Float64}(1.0e6, 0.2), DuSeligEggers{Float64}(1.0, 1.0, 1.0, 6.283185307179586, 0.0), PrandtlTipHub())

pg = PrandtlGlauert()
rotor = Rotor(Rhub, Rtip, B, rotation=du, re=sf, mach=pg)

Rotor{Float64,Int64,Bool,PrandtlGlauert,SkinFriction{Float64},DuSeligEggers{Float64},PrandtlTipHub}(0.012700000000000001, 0.127, 2, 0.0, false, PrandtlGlauert(), SkinFriction{Float64}(1.0e6, 0.2), DuSeligEggers{Float64}(1.0, 1.0, 1.0, 6.283185307179586, 0.0), PrandtlTipHub())

struct TransonicDrag <: MachCorrection
    Mcc  # crest critical Mach number
end

function mach_correction(td::TransonicDrag, cl, cd, Mach)
    beta = sqrt(1 - Mach^2)
    cl /= beta
    cd += 20 * (Mach - td.Mcc)^4  # add estimate for compressibility drag
    return cl, cd
end

Mcc = 0.65
td = TransonicDrag(Mcc)
rotor = Rotor(Rhub, Rtip, B, rotation=du, re=sf, mach=td)

alpha_0 = xfoildata[:, 1] * pi/180
cl_0 = xfoildata[:, 2]
cd_0 = xfoildata[:, 3]

cr75 = 0.128
alpha_ext, cl_ext, cd_ext = viterna(alpha_0, cl_0, cd_0, cr75)

alpha_rot = alpha_ext
cl_rot = similar(cl_ext)
cd_rot = similar(cd_ext)

rR = 0.75  # r/R = 75%
tsr = 6.0  # representative tip-speed ratio

for i = 1:length(cl_ext)
    cl_rot[i], cd_rot[i] = rotation_correction(DuSeligEggers(), cl_ext[i], cd_ext[i], cr75, rR, tsr, alpha_ext[i])
end

using PyPlot

plot(alpha_0, cl_0, label = "original", xlabel = "\\alpha", ylabel = "c_l")
plot!(alpha_ext, cl_ext, label = "extrapolated")
plot!(alpha_rot, cl_rot, label = "rotation")

plot(alpha_0, cd_0, label="original", xlabel = "\\alpha", ylabel = "c_d")
plot!(alpha_ext, cd_ext, label="extrapolated")
plot!(alpha_rot, cd_rot, label="rotation")

af_final = AlphaAF(alpha_rot, cl_rot, cd_rot, "NACA 4412 w/ rotation", 1e6, 0.0)
write_af("/Users/joe/Documents/GitHub/497R-Projects/Rotor Analysis/Airfoils/naca4412.dat", af_final)