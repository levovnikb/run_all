#!/bin/bash

# Run process_ligands.sh and wait for it to finish
./process_ligands.sh

# Run nar_sep_bsh_2.sh and wait for it to finish
./extr_conf.sh

# Run merge.sh and wait for it to finish
./merge_log.sh
