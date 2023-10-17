#!/bin/bash

# Get a list of all TXT files starting with 'log_'
txt_files=(log_*.txt)

# Define the CSV file name
csv_file="merged_logs.csv"

# Write the header row to the CSV file with custom column names
echo "Conformer,Affinity,RMSDLB,RMSDUB,Ligand" > "$csv_file"

# Loop through each TXT file and read its contents
for txt_file in "${txt_files[@]}"; do
    extract=false
    while IFS= read -r line; do
        if [[ "$line" == "-----"* ]]; then
            extract=true
            continue
        elif [[ "$line" == "Writing output"* ]]; then
            extract=false
            continue
        fi

        if "$extract"; then
            # Remove leading and trailing whitespace and split line using spaces as separators into 4 columns
            line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
            columns=($line)
            conformer="${columns[0]}"
            affinity="${columns[1]}"
            rmsdlb="${columns[2]}"
            rmsdub="${columns[3]}"
            ligand="${txt_file#log_}"  # Omit 'log_' prefix
            ligand="${ligand%.txt}"     # Remove file extension

            # Append to CSV file
            echo "$conformer,$affinity,$rmsdlb,$rmsdub,$ligand" >> "$csv_file"
        fi
    done < "$txt_file"
done

echo "Merged log files saved to $csv_file"
