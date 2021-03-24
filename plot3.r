full <- read.table('FE_full.txt')
graph <- read.table('FE_graph_10_0p001.txt')

ZPE <- full$V1[1]
GV1 <- c(ZPE,graph$V1+full$V1[-length(full$V1)])
GV2 <- c(ZPE,graph$V2+full$V2[-length(full$V1)])
GV3 <- c(ZPE,graph$V3+full$V3[-length(full$V1)])
pdf('Red-Blue_Non-interacting2.pdf')
par(mar = c(5, 5, 2, 2))

plot(-5,-5,xlim=c(0.5,6),ylim=c(0,7.5),type='l',ylab="dG (kT)",xlab="Num. Pairs",cex.lab=1.5,cex.axis=1.5,main="Red-Blue_Non-interacting (Sampling effects)")
polygon(c(seq(1,6,1),rev(seq(1,6,1))),c(c(GV2-GV2[1]),rev(c(GV3-GV3[1]))),col=rgb(1,0.9,0.9),lty=3,border=FALSE)
#polygon(c(seq(1,6,1),rev(seq(1,6,1))),c(c(full$V2-full$V2[1]),rev(c(full$V3-full$V3[1]))),col=rgb(0.9,0.9,0.9),lty=3,border=FALSE)

graph <- read.table('FE_graph_10_0p01.txt')
GV1 <- c(ZPE,graph$V1+full$V1[-length(full$V1)])
GV2 <- c(ZPE,graph$V2+full$V2[-length(full$V1)])
GV3 <- c(ZPE,graph$V3+full$V3[-length(full$V1)])
polygon(c(seq(1,6,1),rev(seq(1,6,1))),c(c(GV2-GV2[1]),rev(c(GV3-GV3[1]))),col=rgb(0.7,1,0.7),lty=3,border=FALSE)

graph <- read.table('FE_graph_10.txt')
GV1 <- c(ZPE,graph$V1+full$V1[-length(full$V1)])
GV2 <- c(ZPE,graph$V2+full$V2[-length(full$V1)])
GV3 <- c(ZPE,graph$V3+full$V3[-length(full$V1)])
polygon(c(seq(1,6,1),rev(seq(1,6,1))),c(c(GV2-GV2[1]),rev(c(GV3-GV3[1]))),col=rgb(0.8,0.8,1),lty=3,border=FALSE)

box()
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=16,cex=1,lwd=3,col="purple")
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=1,cex=1,lwd=1)
#lines(seq(1,6,1),c(GV1-GV1[1]),col="red",lwd=2)
#lines(seq(1,6,1),c(full$V1-full$V1[1]),col="blue",lty=3,lwd=2)

# 0.1% data
graph <- read.table('FE_graph_10_0p001.txt')
GV1 <- c(ZPE,graph$V1+full$V1[-length(full$V1)])
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=16,cex=1,lwd=3,col="red")
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=1,cex=1,lwd=2)
#lines(seq(1,6,1),c(GV1-GV1[1]),col="red",lwd=2)


# 1% data
graph <- read.table('FE_graph_10_0p01.txt')
GV1 <- c(ZPE,graph$V1+full$V1[-length(full$V1)])
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=16,cex=1,lwd=3,col="green3")
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=1,cex=1,lwd=2)
#lines(seq(1,6,1),c(GV1-GV1[1]),col="blue",lwd=2)

# 10% data
graph <- read.table('FE_graph_10.txt')
GV1 <- c(ZPE,graph$V1+full$V1[-length(full$V1)])
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=16,cex=1,lwd=3,col="blue")
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=1,cex=1,lwd=1,col="white")
#points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=1,cex=1,lwd=1)
lines(seq(1,6,1),c(GV1-GV1[1]),lwd=1,lty=3)
points(seq(1,6,1),c(full$V1-full$V1[1]),xlim=c(0,12),pch=2,cex=2,col=1,lwd=1)
legend("bottomright",legend=c('Graph (1% data)','Graph (10% data)','Graph (100% data)','Z_n Integrals'),cex=1.5,bg="antiquewhite",pch=c(16,16,16,2),col=c('red','green3','blue','black'),lwd=c(2,2),lty=c(3,3,3,3))
dev.off()
