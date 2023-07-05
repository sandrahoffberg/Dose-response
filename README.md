[![Code Ocean Logo](images/CO_logo_135x72.png)](http://codeocean.com/product)

<hr>

# Dose Response

Format and filter metadata. Only included treated wells with multiple dosages. <br>
Then it fits dose-response curves. <br> 
Then plots dose response curves for every gene in each treatment.

## Input: 

- {sample}.rpm.exp.csv from the Seurat capsule
- Metadata file
- Gene target list


## App Panel Parameters: 

- Path to RPM file
- Metadata file
- Target list

## Output: 
- **/gene_plot** with png files
- **/tx_plot** with png files
- Various output files in pdf and csv format including dose_response_fit.csv and metadata.reformatted.csv



<hr>

[Code Ocean](https://codeocean.com/) is a cloud-based computational platform that aims to make it easy for researchers to share, discover, and run code.<br /><br />
[![Code Ocean Logo](images/CO_logo_68x36.png)](https://www.codeocean.com)