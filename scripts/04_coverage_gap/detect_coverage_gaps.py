#!/usr/bin/env python3

#This script detects coverage gaps from a mosdepth per-base BED file

#Use: python detect_coverage_gaps.py <input_bed_gz> <output_tsv> <sample> <threshold>


###########################
####### PREPARATION #######
###########################

#Import necessary libraries
import os
import sys
import gzip

#Define input arguments
input_bed = sys.argv[1] # Path to the mosdepth per-base BED file
output_tsv = sys.argv[2] # Path to save the output TSV file
sample = sys.argv[3] # Sample name to include in the output
threshold = int(sys.argv[4]) # Coverage threshold to define a gap (e.g., 10)

#Create outpout directory if it doesn't exist
output_dir = os.path.dirname(output_tsv)
os.makedirs(output_dir, exist_ok=True)

###########################
###### GAP DETECTION ######
###########################

#Empty list to store detected gaps
gaps = [] 

#Variables to track the current gap being evaluated
current_gap_start = None # Variable to track the start of a gap
current_gap_end = None # Variable to track the end of a gap
current_gap_chrom = None # Variable to track the chromosome of a gap

#Open the input BED file and iterate through each line
with gzip.open(input_bed, "rt") as f:
    for line in f:
        fields = line.strip().split("\t")

        chrom = fields[0]
        start = int(fields[1])
        end = int(fields[2])
        coverage = int(fields[3])
        
        #If coverage is below or equal to threshold, this interval is in a gap
        if coverage <= threshold:

            #If there is no active gap, start a new one
            if current_gap_chrom is None:
                current_gap_chrom = chrom
                current_gap_start = start
                current_gap_end = end

            #If the interval is contiguous and in the same chromosome
            elif chrom == current_gap_chrom and start == current_gap_end:
                #Extend the current gap
                current_gap_end = end
            
            #If the gap is not contiguous, save the previous gap and start a new one
            else:
                gap_length = current_gap_end - current_gap_start
                gaps.append([
                    sample,
                    current_gap_chrom,
                    current_gap_start,
                    current_gap_end,
                    gap_length,
                    threshold
                ])
                current_gap_chrom = chrom
                current_gap_start = start
                current_gap_end = end

        # If coverage is above threshold, close the current gap if one is open
        else:

            #Close the current gap if one is open
            if current_gap_chrom is not None:
                gap_length = current_gap_end - current_gap_start
                gaps.append([
                    sample,
                    current_gap_chrom,
                    current_gap_start,
                    current_gap_end,
                    gap_length,
                    threshold
                ])

                # Reset gap tracking variables
                current_gap_chrom = None
                current_gap_start = None
                current_gap_end = None

    # If the file ends and a gap is still open, save it
    if current_gap_chrom is not None:
        gap_length = current_gap_end - current_gap_start
        gaps.append([
            sample,
            current_gap_chrom,
            current_gap_start,
            current_gap_end,
            gap_length,
            threshold
        ])

###########################
####### WRITE TSV #########
###########################

with open(output_tsv, "w") as out:
    out.write("sample\tchrom\tgap_start\tgap_end\tgap_length\tthreshold\n")

    for gap in gaps:
        out.write(
            f"{gap[0]}\t{gap[1]}\t{gap[2]}\t{gap[3]}\t{gap[4]}\t{gap[5]}\n"
        )

#Info message of finished process
print("Coverage gap detection completed.")
print(f"Output file: {output_tsv}")
print(f"Number of gaps detected for a threshold of {threshold}: {len(gaps)}")


