#!/usr/bin/bash
set -ex

source ./config.sh

python ./filter_metadata.py

Rscript ./fit_dose_response.R

Rscript ./plot_dosage_curves.R

Rscript ./gene_plot.R
