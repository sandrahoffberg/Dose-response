# Dose Response

### How this capsule works: 

This is the fourth capsule in the pipeline. <br>
Format and filter metadata. Only included treated wells with multiple dosages. <br>
Then it fits dose-response curves. <br> 
Then plots dose response curves for every gene in each treatment.

### Inputs: 

- {sample}.rpm.exp.csv from the Seurat capsule
- Metadata file
- Gene target list

### Outputs: 
- **/gene_plot** with png files
- **/tx_plot** with png files
- Various output files in pdf and csv format including dose_response_fit.csv and metadata.reformatted.csv

### App Panel Parameters: 

- Path to RPM file
- Metadata file
- Treatment
- Target list
- Dose response fits
- gene