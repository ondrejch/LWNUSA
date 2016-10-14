#!/usr/bin/env python3
#
# Generate cells for LWNUSA infinite lattice model
# Ondrej Chvala, ochvala@utk.edu, 2016-10-14

def write_cells():
    '''Function to write cell cards for Serpent input deck.
    Outputs:
        cells:        String containing cell cards'''
    
    cells = '''
%______________cell definitions_____________________________________
cell 10  0  water       -1   % inner water channel
cell 11  0  alu6061   1 -2   % slag clad
cell 12  0  fuel      2 -3   % slag fuel 
cell 13  0  alu6061   3 -4   % slag clad
cell 14  0  water     4 -5   % water gap
cell 15  0  alu6061   5 -6   % water gap
cell 20  0  water     6 -9   % water gap
cell 99  0  outside   9      % graveyard  
'''
    cells = cells.format(**locals())
    return cells

if __name__ == '__main__':
    print("This module writes cells for the LWNUSA lattice.")
    input("Press Ctrl+C to quit, or enter else to test it. ")
    print (write_cells())


