#!/bin/bash

directory="/home/bharath/Lifecell/fastq1"

files=($(ls ${directory}/*_R[12].fastq.gz | sort))

if (( ${#files[@]} % 2 != 0 )); then
    echo "Warning: Odd number of FASTQ files. Some files may be unpaired."
fi

for ((i=0; i<${#files[@]}; i+=2)); do
    if [ $((i+1)) -lt ${#files[@]} ]; then
        sample1=${files[$i]}
        sample2=${files[$i+1]}
        echo "Processing ${sample1} and ${sample2}"
        echo "Files: ${files[@]}"
        
        #use the pipeline command with forward and reverse data
        nextflow run gc.nf --sample1 ${sample1} --sample2 ${sample2} --ref "/home/bharath/Lifecell/ref/hg38.fa" --output_dir "/home/bharath/Lifecell/output" --known_sites "/home/bharath/Lifecell/ref/Homo_sapiens_assembly38.dbsnp138.vcf"
        
        
        if [ $? -ne 0 ]; then
            echo "Nextflow command failed for ${sample1} and ${sample2}"
            exit 1
        fi
    else
        echo "Skipping ${files[$i]} due to no pair."
    fi
done

