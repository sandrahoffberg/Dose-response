#!/usr/bin/env Rscript

library(drda)

args <- commandArgs(trailingOnly=TRUE)


#Load gene expression.
rpm.exp <- read.csv(args[1])
rpm.exp <- rpm.exp[,c('Treatment',args[2])]
rpm.exp[args[2]] <- log2(rpm.exp[args[2]]+1)

#Load dose responses.
dose.responses <- strsplit(args[3],split = ' ')[[1]]

#Perform plotting.
for (fit in sort(dose.responses)) {
    treatment <- strsplit(fit,split = '[.]')[[1]][1]
    fit.fun <- readRDS(fit)
    min.exp <- floor(min(rpm.exp[rpm.exp\$Treatment == treatment,args[2]]))
    max.exp <- ceiling(max(rpm.exp[rpm.exp\$Treatment == treatment,args[2]]))
    png(paste(treatment,'.png',sep = ''),width=960,height=960,res=250)
    plot(fit.fun,xlim=c(-3,1),ylim=c(min.exp,max.exp),legend_show=FALSE,
         xlab='log10 Dosage[uM]',ylab='log2 Gene Exp',main=treatment)
    dev.off()
}