#!/usr/bin/env python

import sys
import getopt
import tempfile
import shutil
import os

# Use vl2smv to generate the .svm file from the .v file.
# Run this script to append the SMV Assertions to the auto-generated .smv file.
# The assertions are given, in smv syntax, in the .v file.
# This script looks for assertions enclosed by '//SMV-Assertions' lines
# and layers enclosed by '//SMV-Layers' lines.
# You can then open the .smv file (with the assertions appended) in vw
# Cynthia Sturton

helpMenu = "Parameters:\n"\
"-v --verilogFileName <file path>\n"\
"-s --smvFileName <file path>\n"\
"-a --includeAssertions\n"\
"-l --includeLayers\n"\
"-h --help\n"



####################### Main #####################################

# Get the command line args
"""if (len(sys.argv) < 6):
    print "\nEnter file names correctly: " + str(len(sys.argv))
    sys.exit(2)
"""
try:
    opts, args = getopt.getopt(sys.argv[1:], "v:s:alh",
                               ["verilogFileName=", "smvFileName=", 
                                "includeAssertions", "includeLayers",
                                "help"])

except getopt.GetoptError:
    print "Error"
    sys.exit(2)

includeAssertions = False
includeLayers = False

for opt, arg in opts:
    if (opt in ("-v", "--verilogFileName")):
        verilogFilePath = arg
        print "verilogFile: " + verilogFilePath
    elif (opt in ("-s", "--smvFileName")):
        smvFilePath = arg
        print "smvFile: " + smvFilePath
    elif (opt in ("-a", "--includeAssertions")):
        includeAssertions = True
        print "includeAssertions: " + str(includeAssertions)
    elif (opt in ("-l", "--includeLayers")):
        includeLayers = True
        print "includeLayers: " + str(includeLayers)
    elif (opt in ("-h", "--help")):
        print helpMenu
        sys.exit()




# Copy the .smv file to a temp file.
# Seek backwards to just before the last '}'.
# Copy in the assertions from the.v file.
# Overwrite the .smv file with the contents of the temp file.

# Open the necessary files
verilogFile = open(verilogFilePath, "r")
smvFile = open(smvFilePath, "r")
tempFile = tempfile.NamedTemporaryFile(mode="w+")

# Copy the .smv file to a temp file. 
for line in smvFile:
    tempFile.write(line)

smvFile.close()

# Seek backwards to just before the last '}' in the .smv/temp file
tempFile.seek(-1,os.SEEK_CUR)
while(tempFile.read(1) != "}"):
    tempFile.seek(-2,os.SEEK_CUR)

tempFile.seek(-1,os.SEEK_CUR)

# Copy everything in the .v file that is between the line
# '//SMV-Assertions'
copyAssertions = False
copyLayers = False

for line in verilogFile:
    if((line.find("//SMV-Assertions") != -1) and includeAssertions):
        copyAssertions = not copyAssertions
    elif((line.find("//SMV-Layers") != -1) and includeLayers):
        copyLayers = not copyLayers
    elif(copyAssertions or copyLayers):
        tempFile.write(line)

verilogFile.close()

# Add back in the last '}' that was overwritten in the last step.
tempFile.write("}")

# Overwrite the original .smv file with the temp file (which now has
# the assertions added in).
tempFile.seek(0)
shutil.copyfile(tempFile.name, smvFilePath)

tempFile.close

