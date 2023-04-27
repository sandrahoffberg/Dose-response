#!/usr/bin/bash
set -ex

source ./config.sh

python ./run_dose_response.py --metadata_file ${metadata} --all_rpm_file ${all_rpm} --target_list ${target_list}

Rscript ./fit_dose_response.R ${metadata} ${target_list} ${all_rpm} ${treatment}

Rscript ./plot_dosage_curves.R ${all_rpm} ${treatment} ${dose_response_fits}

Rscript ./gene_plot.R ${all_rpm} ${gene} ${dose_response_fits}
