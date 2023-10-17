#!/bin/bash

extract_models() {
    local input_file=$1
    local output_prefix=$2
    local model_num=1
    local model_start=-1
    local model_end=-1
    local line_num=1

    while read line; do
        if [[ "$line" =~ ^MODEL[[:space:]]+[0-9]+ ]]; then
            # Start of a new model found
            if [ "$model_start" == -1 ]; then
                model_start=$line_num
            else
                # End of the previous model found
                model_end=$((line_num - 1))
                output_file="${output_prefix}_mod_$(printf "%02d" $model_num).pdbqt"
                head -n $((model_end + 1)) $input_file | tail -n $((model_end - model_start + 1)) > $output_file
                model_num=$((model_num + 1))
                model_start=$line_num
            fi
        elif [[ "$line" =~ ^ENDMDL ]]; then
            # End of the current model found
            model_end=$line_num
            output_file="${output_prefix}_mod_$(printf "%02d" $model_num).pdbqt"
            head -n $((model_end + 1)) $input_file | tail -n $((model_end - model_start + 1)) > $output_file
            model_num=$((model_num + 1))
            model_start=-1
            model_end=-1
        fi
        line_num=$((line_num + 1))
    done < $input_file
}

for input_file in out_*.pdbqt; do
    input_file_base=$(basename $input_file .pdbqt)
    output_prefix="extr_${input_file_base}"
    extract_models $input_file $output_prefix
done
