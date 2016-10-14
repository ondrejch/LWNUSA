#!/usr/bin/env python3
# 
# Write the Serpent deck to a file
# Ondrej Chvala, ochvala@utk.edu


import infdeck
import os

import argparse

# Serpent deck file name
filename = "lwnusa.inp"
dirname  = "./"


# Command line argument
parser = argparse.ArgumentParser(description='Writes Serpent2 input deck for LWNUSA infinite cell.')
parser.add_argument('--pitch', metavar='pitch', type=float, nargs='?', default=10,
                   help='fuel pin pitch [cm], default = 10 cm')

# Parse command line arguments
args   =  vars(parser.parse_args())
pitch  = args['pitch']

# Make the deck
s2_deck = infdeck.write_deck(pitch)

fname   = dirname + filename
print("Writing deck for pitch ", pitch," cm.")

# Write the deck
try:
    f = open(fname, 'w')
    f.write(s2_deck)
    f.close()
    print("Deck written,")
except IOError as e:
    print("Unable to write to file", fname)
    print(e)


