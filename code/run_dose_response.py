#!/usr/bin/env python

import pandas as pd
import numpy as np
import sys
import argparse
import logging
from pathlib import Path
import shlex
import subprocess
import glob

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)

logger = logging.getLogger(__name__)

def main(argv = None):
    parser = argparse.ArgumentParser(description="Filter metadata")
    parser.add_argument("--metadata_file", help="Input metadata", type=Path, required=True)
    parser.add_argument("--all_rpm_file", help="Output RPM from Seurat", type=Path, required=True)
    parser.add_argument("--target_list", help="Input Target List", type=Path, required=True)

    if argv:
        args = parser.parse_args(argv)
    else: 
        parser.print_usage()
        return 0

    if not args.metadata_file.is_file():
        logger.error(f"Missing metadata: {args.metadata}")
        return 1

    if not args.all_rpm_file.is_file():
        logger.error(f"Missing all_rpm: {args.all_rpm}")
        return 1

    if not args.target_list.is_file():
        logger.error(f"Missing all_rpm: {args.target_list}")
        return 1

    
    #Load metadata and retrieve relevant columns.
    metadata = pd.read_csv(args.metadata_file)
    metadata = metadata[['SampleID','Treatment','TreatmentDosageTreatTime',
                         'Dosage[uM]']]

    #Load expression data.
    all_rpm = pd.read_csv(args.all_rpm_file)

    #Remove untreated wells. Retain treatments that occur in treatment condition.
    metadata = metadata[(metadata.Treatment != 'none') &
                        (metadata.Treatment.isin(all_rpm.Treatment.unique()))]

    #Remove wells without multiple dosages.
    num_dosages = metadata.groupby('Treatment')['Dosage[uM]'].nunique()
    metadata = metadata[metadata.Treatment.isin(num_dosages[num_dosages > 1].index)]

    #Log normalize dosage.
    metadata['Dosage[uM]'] = np.log10(metadata['Dosage[uM]'])

    filtered_metadata_file = "../results/metadata.reformatted.csv"
    
    #Output reformatted metadata to CSV.
    metadata.to_csv("../results/metadata.reformatted.csv",index=False)
    
    #Run dosage plots per treatment type
    for treatment in set(metadata['Treatment']): 
        cmd = f'Rscript ./fit_dose_response.R {filtered_metadata_file} {args.target_list} {args.all_rpm_file} {treatment}'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))
        
        output_dose_responses = glob.glob(f"../results/{treatment}.*.RDS")

        output_list = " ".join(output_dose_responses)
        
        #generate treatment plot
        cmd = f'Rscript ./tx_plot.R {args.all_rpm_file} {treatment} "{output_list}"'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))
        
    
    #Run dosage plots per gene
    for dose_response_fit in output_dose_responses:
        dose_response_name = Path(dose_response_fit).name
        treatment, gene, _ = dose_response_name.split('.')
        
        cmd = f'Rscript ./plot_dosage_curves.R {args.all_rpm_file} {treatment} {dose_response_fit}'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))

    #for 
    #Rscript ./gene_plot.R ${all_rpm} ${gene} ${dose_response_fits}


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))