#!/usr/bin/env Rscript

library(drda)

args <- commandArgs(trailingOnly=TRUE)

#Load gene expression.
rpm.exp <- read.csv(args[1])
rpm.exp <- rpm.exp[rpm.exp$Treatment == args[2],7:dim(rpm.exp)[2]]
rpm.exp <- log2(rpm.exp+1)

#Load dose responses.
dose.responses <- strsplit(args[3], split = ' ')[[1]]

#Perform plotting.
for (fit in sort(dose.responses)) {

  gene <- strsplit(fit,split = '[.]')[[1]][4]
  fit.fun <- readRDS(fit)

  min.exp <- floor(min(rpm.exp[,gene]))
  max.exp <- ceiling(max(rpm.exp[,gene]))

  out_png = paste(args[2], gene,'png',sep = '.')
  out_png = paste(args[4], out_png, sep="")
  
  png(out_png,width=960,height=960,res=250)
  plot(fit.fun,xlim=c(-3,1),ylim=c(min.exp,max.exp),legend_show=FALSE,
    xlab='log10 Dosage[uM]',ylab='log2 Gene Exp',main=gene)
  dev.off()
}
