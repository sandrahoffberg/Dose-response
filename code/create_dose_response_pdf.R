#!/usr/bin/env Rscript

library(png)
library(grid)
library(gridExtra)
library(ggplot2)

args <- commandArgs(trailingOnly=TRUE)

plots <- lapply(ll <- strsplit(args[1],split = ' ')[[1]], function(x){
  img <- as.raster(readPNG(x))
  rasterGrob(img, interpolate = FALSE)
})

ggsave(paste("../results/", args[2], '.pdf', sep=''), marrangeGrob(grobs=plots,
                                    layout_matrix = matrix(1:16,  nrow = 4,
                                    ncol=4, byrow=TRUE)))