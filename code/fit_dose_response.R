#!/usr/bin/env Rscript
library(drda)

args <- commandArgs(trailingOnly=TRUE)

metadata_file <- args[1]
target_file <- args[2]
gene_expression_file <- args[3]
treatment_type <- args[4]
output_dir <- args[5]

#Load metadata.
metadata <- read.csv(metadata_file)
    
#Load targets.
targets <- read.csv(target_file)[,1]
    
#Load gene expression.
rpm.exp <- read.csv(gene_expression_file)
rpm.exp <- rpm.exp[rpm.exp$Treatment == treatment_type,
                    c("SampleID","Treatment","TreatmentDosageTreatTime",
                      targets)]
rpm.exp[,targets] <- log2(rpm.exp[,targets]+1)
    
#Merge expression and metadata information.
merged.exp <- merge(metadata, rpm.exp, by = c('SampleID','Treatment',
                                              'TreatmentDosageTreatTime'))
    
#Remove unexpressed genes.
merged.exp <- merged.exp[, colSums(merged.exp != 0) > 0]
tx.genes <- colnames(merged.exp)[5:dim(merged.exp)[2]]
    
#Record the dose response information.
tx_by_gene_stats <- data.frame(cmpd=character(),gene=character(),
                                min.exp=numeric(),max.exp=numeric(),
                                gene.logEC50=numeric(),gene.delta=numeric(),
                                gene.eta=numeric())
    
#Iterate through expressed genes.
for (gene in tx.genes) {
    fit <- try(drda(as.formula(paste(gene,'~','Dosage.uM.',sep=' ')),
                    data = merged.exp))
    if(inherits(fit, "try-error")) next
      
    rds_out <- paste(treatment_type, gene,'RDS',sep='.')
    rds_out <- paste(output_dir, rds_out,sep='')
    #Output dose-response fits.
    saveRDS(fit, file = rds_out)
      
    #Store relevant stats.
    min.exp <- floor(min(merged.exp[,gene]))
    max.exp <- ceiling(max(merged.exp[,gene]))
    tx_by_gene_stats[nrow(tx_by_gene_stats)+1,] <- c(args[3],gene,
                                                    min.exp,max.exp,
                                                    coef(fit)[4],
                                                    coef(fit)[2],
                                                    coef(fit)[3])
}

#Output fitting stats.
write.csv(tx_by_gene_stats,file = paste(output_dir,treatment_type,'.stats.csv', sep=''),row.names = FALSE)
