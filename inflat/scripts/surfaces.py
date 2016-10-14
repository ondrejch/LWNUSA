#!/usr/bin/env python3
#
# Generate surfaces for the LWNUSA Serpent deck
# Ondrej Chvala, ochvala@utk.edu, 2016-10-14


def write_surfaces(pitch = 10.0, 
    r1=0.580, r2=0.707, r3=1.398, r4=1.525, 
    r5=3.180, r6=3.310):
    '''Function to write material cards for Serpent input deck.
    Inputs: [cm]
        pitch:     channel pitch
        r1:        slug water channel / inner clad radius
        r2:        outer clad / inner fuel radius
        r3:        outer fuel radius
        r4:        outer clad radius / water in the tube
        r5:        inner tube radius
        r6:        outer tube radius
    Outputs:
        surfaces: String containing the surface cards'''

    l = pitch/2.0
    if not ( r1<r2 and r2<r3 and r3<r4 and r4<r5 and r5<r6 and r6<l ) :
        quit("Inconsistent input!")

    surfaces = '''
%______________surface definitions__________________________________
surf 1  cyl    0.0 0.0 {r1} % slug water channel / inner clad radius
surf 2  cyl    0.0 0.0 {r2} % outer clad / inner fuel radius
surf 3  cyl    0.0 0.0 {r3} % outer fuel radius
surf 4  cyl    0.0 0.0 {r4} % outer clad radius / water in the tube
surf 5  cyl    0.0 0.0 {r5} % inner tube radius
surf 6  cyl    0.0 0.0 {r6} % outer tube radius
surf 9  sqc    0.0 0.0 {l}  % water box
'''
    surfaces = surfaces.format(**locals())
    return surfaces

if __name__ == '__main__':
    print("This module writes surfaces for the MSBR lattice.")
    input("Press Ctrl+C to quit, or enter else to test it.")
    print(write_surfaces())

