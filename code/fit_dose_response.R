#!/usr/bin/env Rscript
library(drda)

args <- commandArgs(trailingOnly=TRUE)

#Load metadata.
metadata <- read.csv(args[1])
    
#Load targets.
targets <- read.csv(args[2])[,1]
    
#Load gene expression.
rpm.exp <- read.csv(args[3])
rpm.exp <- rpm.exp[rpm.exp\$Treatment == args[3],
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
      
    #Output dose-response fits.
    saveRDS(fit,file = paste(args[3],gene,'RDS',sep='.'))
      
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
write.csv(tx_by_gene_stats,file = paste('../results/',args[3],'.stats.csv'),row.names = FALSE)