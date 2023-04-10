#!/usr/bin/env Rscript
library(drda)

#Load gene expression.
rpm.exp <- read.csv(all_rpm)
rpm.exp <- rpm.exp[,c('Treatment','${gene}')]
rpm.exp[gene] <- log2(rpm.exp[gene]+1)

#Load dose responses.
dose.responses <- strsplit(dose_response_fits,split = ' ')[[1]]

#Perform plotting.
for (fit in sort(dose.responses)) {
    treatment <- strsplit(fit,split = '[.]')[[1]][1]
    fit.fun <- readRDS(fit)
    min.exp <- floor(min(rpm.exp[rpm.exp\$Treatment == treatment,'${gene}']))
    max.exp <- ceiling(max(rpm.exp[rpm.exp\$Treatment == treatment,'${gene}']))
    png(paste(treatment,'.png',sep = ''),width=960,height=960,res=250)
    plot(fit.fun,xlim=c(-3,1),ylim=c(min.exp,max.exp),legend_show=FALSE,
         xlab='log10 Dosage[uM]',ylab='log2 Gene Exp',main=treatment)
    dev.off()
}