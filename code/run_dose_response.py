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
        Path("../results/tx_plot").mkdir(exist_ok=True)

        cmd = f'Rscript ./tx_plot.R {args.all_rpm_file} {treatment} "{output_list}" ../results/tx_plot/'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))
        
        output_pngs = glob.glob(f"../results/tx_plot/{treatment}*.png")
        output_list = " ".join(output_pngs)
        
        cmd = f'Rscript ./create_dose_response_pdf.R "{output_list}" "{treatment}"'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))

    output_dose_responses = glob.glob(f"../results/*.RDS")
    genes = set()
    for dose_response in output_dose_responses:
      dose_response_name = Path(dose_response).name
      treatment, gene, _ = dose_response_name.split('.')
      genes.add(gene)
    
    #Run dosage plots per gene
    for gene in genes:
        dose_responses = glob.glob(f"../results/*{gene}.RDS")
        dose_responses = " ".join(dose_responses)

        Path("../results/gene_plot").mkdir(exist_ok=True)
        
        cmd = f'Rscript ./gene_plot.R {args.all_rpm_file} {gene} "{dose_responses}" ../results/gene_plot/'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))
        
        output_pngs = glob.glob(f"../results/gene_plot/{gene}*.png")
        output_list = " ".join(output_pngs)
        
        cmd = f'Rscript ./create_dose_response_pdf.R "{output_list}" "{gene}"'
        logger.info(cmd)
        subprocess.check_call(shlex.split(cmd))
        
    #aggregate stats
    stats = glob.glob("../results/*.stats.csv")
    logger.info(stats)

    stats_dfs = [pd.read_csv(x) for x in stats]
    out_df = pd.concat(stats_dfs).sort_values(['cmpd','gene'])

    out_df.to_csv('../results/dose_response_fit.csv',index=False)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
