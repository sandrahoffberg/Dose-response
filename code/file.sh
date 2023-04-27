#!/usr/bin/bash
set -ex

source ./config.sh

python ./filter_metadata.py --metadata_file ${metadata} --all_rpm_file ${all_rpm}

Rscript ./fit_dose_response.R ${metadata} ${target_list} ${all_rpm} ${treatment}

Rscript ./plot_dosage_curves.R ${all_rpm} ${treatment} ${dose_response_fits}

Rscript ./gene_plot.R ${all_rpm} ${gene} ${dose_response_fits}
