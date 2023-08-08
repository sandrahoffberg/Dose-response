#!/usr/bin/env Rscript

library(drda)
library(png)
library(grid)
library(gridExtra)
library(ggplot2)

source("config.R", local=TRUE)

#Remove unexpressed genes.
expressed_genes <- gene_expression_file[, colSums(gene_expression_file != 0) > 0]
expressed_gene_names <- colnames(expressed_genes)[3:dim(expressed_genes)[2]]

# Log normalize the response (base 10)
expressed_genes[,expressed_gene_names] <- log2(expressed_genes[,expressed_gene_names]+1)

# Log normalize dosage (base 2)
expressed_genes['Dosage'] = log10(expressed_genes['Dosage'])


dir.create("/results/plot_by_gene/")
dir.create("/results/RDS/")


#Record the dose response information.
tx_by_gene_stats <- data.frame(cmpd=character(),gene=character(),
                               min.exp=numeric(),max.exp=numeric(),
                               gene.logEC50=numeric(),gene.delta=numeric(),
                               gene.eta=numeric())

#Iterate through expressed genes.
for (gene in expressed_gene_names) {
  fit <- try(drda(as.formula(paste(gene,'~','Dosage',sep=' ')),
                  data = expressed_genes))
  if(inherits(fit, "try-error")) next
  
  rds_out <- paste(gene,'RDS',sep='.')
  rds_out <- paste("../results/RDS/", rds_out,sep='')
  #Output dose-response fits.
  saveRDS(fit, file = rds_out)
  
  
  #Store relevant stats.
  min.exp <- floor(min(expressed_genes[,gene]))
  max.exp <- ceiling(max(expressed_genes[,gene]))
  tx_by_gene_stats[nrow(tx_by_gene_stats)+1,] <- c(response_data,gene,
                                                   min.exp,max.exp,
                                                   coef(fit)[4],
                                                   coef(fit)[2],
                                                   coef(fit)[3])

  # Plot the curve for each gene
  png(paste("../results/plot_by_gene/", gene, ".png", sep=""),width=960,height=960,res=250)
  plot(fit,legend_show=FALSE, xlim=c(-3,1),ylim=c(min.exp,max.exp),
       xlab='log10 Dosage',ylab='log2 Gene Exp',main=gene)
  dev.off()
  
  }

# Output fitting stats.
write.csv(tx_by_gene_stats,file = paste("../results/stats_",basename(response_data), sep=''),row.names = FALSE)




# Plot all of the curves in a single PDF
plots <- lapply(ll <- strsplit(expressed_gene_names,split = ' '), function(x){
  img <- as.raster(readPNG(paste("/results/plot_by_gene/", x, ".png", sep="")))
  rasterGrob(img, interpolate = FALSE)
})

ggsave("/results/all.pdf", marrangeGrob(grobs=plots, 
                                        layout_matrix = matrix(1:16,nrow = 4,ncol=4,byrow=TRUE)))
