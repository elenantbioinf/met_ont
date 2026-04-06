#!/usr/bin/env python3

#This script compares QC metrics between different BAM files

# Use: python compare_qc.py <sample_name> <results_dir> <output_dir>


###########################
####### PREPARATION #######
###########################

#Import necessary libraries
import sys
import os

#Define input arguments
sample_name = sys.argv[1]
results_dir = sys.argv[2]
output_dir = sys.argv[3]

#Create outpout directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)


###########################
### FLAGSTAT COMPARISON ###
###########################

#Define paths to flagstat files and output flagstat TSV file
raw_flagstat = f"{results_dir}/01_initial_qc/samtools/{sample_name}_flagstat.txt"
filtered_flagstat = f"{results_dir}/02_post_filtering_qc/samtools/{sample_name}_filtered_flagstat.txt"
flagstat_output_tsv = f"{output_dir}/{sample_name}_flagstat_comparison.tsv"

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

#Create a table to compare the flagstat metrics and save to a TSV file
with open(flagstat_output_tsv, "w") as out:
    out.write("sample\tstate\ttotal\tmapped\tprimary\tsecondary\tsupplementary\n")
    out.write(
        f"{sample_name}\traw\t{raw_metrics['total']}\t{raw_metrics['mapped']}\t{raw_metrics['primary']}\t{raw_metrics['secondary']}\t{raw_metrics['supplementary']}\n"
    )
    out.write(
        f"{sample_name}\tfiltered\t{filtered_metrics['total']}\t{filtered_metrics['mapped']}\t{filtered_metrics['primary']}\t{filtered_metrics['secondary']}\t{filtered_metrics['supplementary']}\n"
    )

print("Flagstat comparison completed.")
print(f"Flagstat comparison file: {flagstat_output_tsv}")


###########################
#### STATS COMPARISON ####
###########################

#Define paths to stats files and output stats TSV file
raw_stats = f"{results_dir}/01_initial_qc/samtools/{sample_name}_stats.txt"
filtered_stats = f"{results_dir}/02_post_filtering_qc/samtools/{sample_name}_filtered_stats.txt"
stats_output_tsv = f"{output_dir}/{sample_name}_stats_comparison.tsv"

#Define a function to extract relevant metrics from stats output
def extract_stats_metrics(stats_file):
    metrics = {
        "reads_mapped": "",
        "reads_MQ0": "",
        "non_primary_alignments": "",
        "supplementary_alignments": "",
        "bases_mapped_cigar": "",
        "error_rate": "",
        "average_length": "",
        "maximum_length": ""
    }

    with open(stats_file, "r") as f:
        for line in f:
            line = line.strip()

            if not line.startswith("SN"):
                continue

            if "reads mapped:" in line and "paired" not in line:
                metrics["reads_mapped"] = int(line.split("\t")[2])
            elif "reads MQ0:" in line:
                metrics["reads_MQ0"] = int(line.split("\t")[2])
            elif "non-primary alignments:" in line:
                metrics["non_primary_alignments"] = int(line.split("\t")[2])
            elif "supplementary alignments:" in line:
                metrics["supplementary_alignments"] = int(line.split("\t")[2])
            elif "bases mapped (cigar):" in line:
                metrics["bases_mapped_cigar"] = int(line.split("\t")[2])
            elif "error rate:" in line:
                metrics["error_rate"] = float(line.split("\t")[2])
            elif "average length:" in line and "first fragment" not in line and "last fragment" not in line:
                metrics["average_length"] = int(line.split("\t")[2])
            elif "maximum length:" in line and "first fragment" not in line and "last fragment" not in line:
                metrics["maximum_length"] = int(line.split("\t")[2])

    return metrics

#Extract metrics from both stats files
raw_stats_metrics = extract_stats_metrics(raw_stats)
filtered_stats_metrics = extract_stats_metrics(filtered_stats)

#Create a table to compare the stats metrics and save to a TSV file
with open(stats_output_tsv, "w") as out:
    out.write("sample\tstate\treads_mapped\treads_MQ0\tnon_primary_alignments\tsupplementary_alignments\tbases_mapped_cigar\terror_rate\taverage_length\tmaximum_length\n")
    out.write(
        f"{sample_name}\traw\t{raw_stats_metrics['reads_mapped']}\t{raw_stats_metrics['reads_MQ0']}\t{raw_stats_metrics['non_primary_alignments']}\t{raw_stats_metrics['supplementary_alignments']}\t{raw_stats_metrics['bases_mapped_cigar']}\t{raw_stats_metrics['error_rate']}\t{raw_stats_metrics['average_length']}\t{raw_stats_metrics['maximum_length']}\n"
    )
    out.write(
        f"{sample_name}\tfiltered\t{filtered_stats_metrics['reads_mapped']}\t{filtered_stats_metrics['reads_MQ0']}\t{filtered_stats_metrics['non_primary_alignments']}\t{filtered_stats_metrics['supplementary_alignments']}\t{filtered_stats_metrics['bases_mapped_cigar']}\t{filtered_stats_metrics['error_rate']}\t{filtered_stats_metrics['average_length']}\t{filtered_stats_metrics['maximum_length']}\n"
    )

print("Stats comparison completed.")
print(f"Stats comparison file: {stats_output_tsv}")