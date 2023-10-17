#!/bin/bash

# Check if vina executable exists
if [ ! -x "./vina" ]; then
    echo "Error: 'vina' executable not found."
    exit 1
fi

# Loop through ligand files and process them
for f in lig_*.pdbqt; do
    if [ -f "$f" ]; then
        b=$(basename "$f" .pdbqt)
        echo "Processing ligand $b"
        ./vina --config conf.txt --ligand "$f" --out "out_${b}.pdbqt" --log "log_${b}.txt"
        if [ $? -eq 0 ]; then
            echo "Ligand $b processed successfully."
        else
            echo "Error processing ligand $b."
        fi
    else
        echo "Ligand file '$f' not found."
    fi
done

echo "All ligands processed."
