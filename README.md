[![Code Ocean Logo](images/CO_logo_135x72.png)](http://codeocean.com/product)

<hr>

# Plot dose response curves

This capsule uses the R package drda to fit logistic functions to observed dose-response continuous
data (gene expression) and evaluate goodness-of-fit measures.  This capsule can accommodate a single treatment per run. 

## Input: 
In the **/data** directory, a CSV file with the sample in the first column, dosage in the second column, and the expression of each gene in subsequent columns.  


## App Panel Parameters: 
Path to input CSV file 


## Output: 

- **/results/RDS/** containing an .RDS file with the model for the non-linear growth curves for each gene.
- **/results/plots_by_gene** containing a .PNG file plotting the log10 dosage by the log2 gene expression for each gene.
- all.pdf: the dose response curves for each gene
- stats_{input_file_name}.csv: a table containing the input data file, the gene, minimum expression, maximum expression, phi coefficient (half-maximal effective concentration), delta coefficient, and eta coefficient

## Cite

Malyutina, A., Tang, J., & Pessia, A. (2023). drda: An R Package for Dose-Response Data Analysis Using Logistic Functions. Journal of Statistical Software, 106(4), 1–26. https://doi.org/10.18637/jss.v106.i04

<hr>

[Code Ocean](https://codeocean.com/) is a cloud-based computational platform that aims to make it easy for researchers to share, discover, and run code.<br /><br />
[![Code Ocean Logo](images/CO_logo_68x36.png)](https://www.codeocean.com)