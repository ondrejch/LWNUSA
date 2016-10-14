#!/usr/bin/env python3
#
# Materials: Writes the material cards for the Serpent input deck.
# Ondrej Chvala, ochvala@utk.edu
# 2016-10-14

def write_materials(lib='03c'):
    '''Function to write material cards for Serpent input deck.
Inputs: 
    lib:    String containing the neutron cross section library to use.
Outputs:
    mats:    String containing the material cards'''
    
    mats = '''
%-------material definition--------------

mat fuel -19.10 tmp 300.0 rgb 190 10 100    % Fuel is NU metal
92234.03c   -0.000057       % U-234
92235.03c   -0.007204       % U-235
92238.03c   -0.992739       % U-238

mat lead -11.34 tmp 300.0 rgb 10 20 195
82204.03c   -0.014          % Pb-204
82206.03c   -0.241          % Pb-206
82207.03c   -0.221          % Pb-207
82208.03c   -0.524          % Pb-208

mat air -0.001205 tmp 300 rgb 200 200 200   % Dry air, sea level
 6000.03c   -0.000124
 7014.03c   -0.755268
 8016.03c   -0.231781
18040.03c   -0.012827

mat water -0.998207 tmp 300 rgb 100 100 250 % De-aerated water at 1 atm.
  1001.03c  -0.111894
  8016.03c  -0.888106

mat aluminum -2.698900 tmp 300.0 rgb 80 120 235
 13027.03c  -1.000000

mat alu6061 -2.70 tmp 300.0 rgb 120 120 235
 12000.03c  -0.010000
 13027.03c  -0.972000
 14000.03c  -0.006000
 22000.03c  -0.000880
 24000.03c  -0.001950
 25055.03c  -0.000880
 26000.03c  -0.004090
 29000.03c  -0.002750
 30000.03c  -0.001460

% --- "Steel, Stainless 304" [PNNL-15870, Rev. 1]
mat ssteel -7.99949E+00 tmp 300.0 rgb 120 120 120
  6012.03c  -3.95366E-04
 14028.03c  -4.59332E-03
 14029.03c  -2.41681E-04
 14030.03c  -1.64994E-04
 15031.03c  -2.30000E-04
 16032.03c  -1.42073E-04
 16033.03c  -1.15681E-06
 16034.03c  -6.75336E-06
 16036.03c  -1.68255E-08
 24050.03c  -7.93000E-03
 24052.03c  -1.59029E-01
 24053.03c  -1.83798E-02
 24054.03c  -4.66139E-03
 25055.03c  -1.00000E-02
 26054.03c  -3.96166E-02
 26056.03c  -6.44901E-01
 26057.03c  -1.51600E-02
 26058.03c  -2.05287E-03
 28058.03c  -6.21579E-02
 28060.03c  -2.47678E-02
 28061.03c  -1.09461E-03
 28062.03c  -3.54721E-03
 28064.03c  -9.32539E-04
'''
    mats = mats.format(**locals())
    return mats

if __name__ == '__main__':
    print("This module writes materials for LWNUSA Serpent deck.")
    input("Press Ctrl+C to quit, or enter else to test it. ")
    print(write_materials())

