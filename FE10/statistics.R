#!/usr/bin/env Rscript

FE <- read.table('full.dat')$V1
# Store results and error bars 
Stats <- cbind(mean(FE),max(FE),min(FE))
write.table(Stats,file = paste0('Stats'),row.names = F,col.names = c("mean","max","min"))
