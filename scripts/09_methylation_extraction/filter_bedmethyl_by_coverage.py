#!/usr/bin/env python3

#This script filters a bedMethyl file by coverage using a coverage threshold

#It receives a directory containing the phased bedMethyl files and applies
#coverage thresholds internally:
#combined = 10
#hp1 = 5
#hp2 = 5

#Use: python filter_bedmethyl_by_coverage.py <bedmethyl_phased_directory>


###########################
####### PREPARATION #######
###########################

#Import necessary libraries
import os
import sys
import gzip
import glob

#Define input arguments
input_dir = sys.argv[1] #Path to the input bedMethyl files directory

#Define output directory
sample_dir = os.path.dirname(input_dir)
output_dir = os.path.join(sample_dir, "bedmethyl_phased_filtered")

#Create output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)


###########################
#LOOK FOR BEDMETHYL FILES##
###########################

#Find all bedMethyl files in the input directory
bedmethyl_files = glob.glob(os.path.join(input_dir, "*.bed.gz"))

#Print found bedMethyl files
print(f"Found {len(bedmethyl_files)} bedMethyl files in {input_dir}.")
for file in bedmethyl_files:
    print(f" - {file}")

#Stop if no bedMethyl files were found
if not bedmethyl_files:
    print(f"No bedMethyl files found in {input_dir}. Exiting.")
    sys.exit(1)

###########################
####COVERAGE FILTERING ####
###########################

#Iterate through each bedMethyl file
for bedmethyl_original in bedmethyl_files:
    
    #Define coverage thresholds based on file name
    if "_combined.bed.gz" in bedmethyl_original:
        coverage_threshold = 10
    elif "_hp1.bed.gz" in bedmethyl_original:
        coverage_threshold = 5
    elif "_hp2.bed.gz" in bedmethyl_original:
        coverage_threshold = 5
    else:
        print(f"Skipping {bedmethyl_original} because it is not combined or phased.")
        continue

    #Define output file path
    bedmethyl_name = os.path.basename(bedmethyl_original).replace(".bed.gz", "")
    bedmethyl_filtered = os.path.join(
        output_dir, 
        f"{bedmethyl_name}_cov{coverage_threshold}.bed.gz"
    )

    #Open the bedMethyl file
    with gzip.open(bedmethyl_original, "rt") as infile, gzip.open(bedmethyl_filtered, "wt") as outfile:

        #Iterate lines in infile
        for line in infile:
            
            #Separate fields
            fields = line.strip().split("\t")

            #Keep the lines where column 10 is greater than or equal to the coverage threshold
            if int(fields[9]) >= coverage_threshold:
                outfile.write(line)

    print(f"Filtered file created: {bedmethyl_filtered}")