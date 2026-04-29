#!/usr/bin/env python3

#This script converts a VCF file to an annotation table

#Use: python vcf_to_annotation_table.py <input_vcf_gz> <caller>


###########################
####### PREPARATION #######
###########################

#Import necessary libraries
import os
import sys
import gzip 

#Define input arguments
vcf_annotated = sys.argv[1] #Path to the input VCF file
caller = sys.argv[2] #Variant caller used

#Sample name
sample_name = os.path.basename(vcf_annotated).replace(f"_{caller}_vep_annotated.vcf.gz", "")

#Define output path
output_dir = f"results/08_annotation/vep_local/{caller}/{sample_name}"
output_tsv = f"{output_dir}/{sample_name}_{caller}_annotation_table.tsv"

#Create output directory if it doesn't exist
os.makedirs(output_dir, exist_ok=True)


###########################
## CREATE HEADER OF TSV ###
###########################

#Define the columns of csq annotation based on the VCF header

#Initialize variable to store CSQ columns
csq_columns = None

#Open the annotated VCF file and iterate through each line
with gzip.open(vcf_annotated, "rt") as vcf:
    for line in vcf:

        #Find the VEP CSQ line
        if line.startswith("##INFO=<ID=CSQ"):

            #Keep only the text after "Format: "
            csq_text = line.strip().split("Format: ")[1]
        
            #Remove the trailing '">'
            csq_text = csq_text.rstrip('">')

            #Split CSQ column names by '|'
            csq_columns = csq_text.split("|")

            break

#Stop if CSQ columns were not found in the VCF header
if csq_columns is None:
    print("Error: CSQ columns not found in VCF header.")
    sys.exit(1)

#Define base columns from the VCF
base_columns = ["sample", "caller", "CHROM", "POS", "ID", "REF", "ALT", "QUAL", "FILTER", "GT", "PS"]

#Combine base columns with CSQ columns for the final TSV header
tsv_header = base_columns + csq_columns


###########################
### READ VCF VARIANTS #####
###########################

#Initialize list to store variant annotations
variant_annotations = []

#Open the annotated VCF file and iterate through each line
with gzip.open(vcf_annotated, "rt") as vcf:
    for line in vcf:

        #Skip header lines
        if line.startswith("#"):
            continue

        #Split the line into fields
        fields = line.strip().split("\t")

        #Extract basic VCF information
        chrom = fields[0]
        pos = fields[1]
        var_id = fields[2]
        ref = fields[3]
        alt = fields[4]
        qual = fields[5]
        filter_status = fields[6]
        info = fields[7]
        format_field = fields[8]
        sample_field = fields[9]

        #Define format keys and sample values
        format_keys = format_field.split(":")
        sample_values = sample_field.split(":")

        #Create a dictionary to store sample information based on the format keys and sample values
        sample_info = dict(zip(format_keys, sample_values))

        #Extract genotype and phase set information from the sample info
        genotype = sample_info.get("GT", "")
        phase_set = sample_info.get("PS", "")

        #If genotype or phase set information is missing, replace with "."
        if genotype == "":
            genotype = "."
        if phase_set == "":
            phase_set = "."

        #Extract CSQ annotation from INFO field
        csq_annotation = info.split("CSQ=")[1]

        #If there are several CSQ annotations, keep each one separately
        csq_records = csq_annotation.split(",")

        for csq_record in csq_records:

            #Split CSQ annotation values by '|'
            csq_values = csq_record.split("|")
            
            #Fill missing values with "."
            for i in range(len(csq_values)):
                if csq_values[i] == "":
                    csq_values[i] = "."

            #Define base values for the output table
            base_values = [sample_name, caller, chrom, pos, var_id, ref, alt, 
                           qual, filter_status, genotype, phase_set]
            
            #Store complete annotation row
            variant_annotations.append(base_values + csq_values)


###########################
#### WRITE OUTPUT TSV #####
###########################

#Open output TSV file
with open(output_tsv, "w") as out:

    #Write TSV header
    out.write("\t".join(tsv_header) + "\n")

    #Write variant annotation rows
    for row in variant_annotations:
        out.write("\t".join(row) + "\n")

print("Annotation table created successfully.")
print(f"Input VCF: {vcf_annotated}")
print(f"Output TSV: {output_tsv}")