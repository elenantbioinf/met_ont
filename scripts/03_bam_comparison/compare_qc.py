#!/usr/bin/env python3

#This script compares QC metrics between different BAM files

# Use: python compare_qc.py <sample_name> <raw_flagstat> <filtered_flagstat> <output_tsv>

#Import necessary libraries
import sys
import os

#Define input arguments
sample_name = sys.argv[1]
raw_flagstat = sys.argv[2]
filtered_flagstat = sys.argv[3]
output_tsv = sys.argv[4]

#Define a function to extract relevant metrics from flagstat output
def extract_flagstat_metrics(flagstat_file):
    metrics = {
        "total": "",
        "mapped": "",
        "primary": "",
        "secondary": "",
        "supplementary": ""
    }
    with open(flagstat_file, 'r') as f:
        for line in f:
            line = line.strip()
            if 'in total' in line:
                metrics['total'] = int(line.split()[0])
            elif 'mapped (' in line and 'primary' not in line:
                metrics['mapped'] = int(line.split()[0])
            elif line.endswith(" primary"):
                metrics['primary'] = int(line.split()[0])
            elif line.endswith(" secondary"):
                metrics['secondary'] = int(line.split()[0])
            elif line.endswith(" supplementary"):
                metrics['supplementary'] = int(line.split()[0])
    return metrics

#Extract metrics from both flagstat files
raw_metrics = extract_flagstat_metrics(raw_flagstat)
filtered_metrics = extract_flagstat_metrics(filtered_flagstat)

#Create outpout directory if it doesn't exist
output_dir = os.path.dirname(output_tsv)
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

#Create a table to compare the metrics and save to a TSV file
with open(output_tsv, "w") as out:
    out.write("sample\tstate\ttotal\tmapped\tprimary\tsecondary\tsupplementary\n")
    out.write(
        f"{sample_name}\traw\t{raw_metrics['total']}\t{raw_metrics['mapped']}\t{raw_metrics['primary']}\t{raw_metrics['secondary']}\t{raw_metrics['supplementary']}\n"
    )
    out.write(
        f"{sample_name}\tfiltered\t{filtered_metrics['total']}\t{filtered_metrics['mapped']}\t{filtered_metrics['primary']}\t{filtered_metrics['secondary']}\t{filtered_metrics['supplementary']}\n"
    )

print("QC comparison completed.")
print(f"QC comparison: {output_tsv}")
