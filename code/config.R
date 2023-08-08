#!/usr/bin/env Rscript
system("set -ex")

## Passing Args
args <- commandArgs(trailingOnly=TRUE)


if (length(args) == 0 | nchar(args[1])==0) {
    response_data <- list.files(path = "../data", pattern = ".*response.*", full.names = TRUE, recursive=TRUE)
} else {
    response_data <- args[1]
}
print(paste("Dose response data file:", response_data))

# Load expression data
gene_expression_file <- read.csv(response_data)
