full <- read.table('FE_full.txt')
graph <- read.table('FE_graph_10.txt')
ZPE <- full$V1[1]
GV1 <- c(ZPE,cumsum(graph$V1)+ZPE)
GV2 <- c(ZPE,cumsum(graph$V2)+ZPE)
GV3 <- c(ZPE,cumsum(graph$V3)+ZPE)
pdf('Red-Blue_Non-interacting.pdf')
par(mar = c(5, 5, 2, 2))

plot(-5,-5,xlim=c(0.5,6),ylim=c(0,7.5),type='l',ylab="dG (kT)",xlab="Num. Pairs",cex.lab=1.5,cex.axis=1.5,main="Red-Blue (Non Interacting)")
polygon(c(seq(1,6,1),rev(seq(1,6,1))),c(c(GV2-GV2[1]),rev(c(GV3-GV3[1]))),col=rgb(0.8,1,0.8),lty=3,border=FALSE)
points(seq(1,6,1),c(full$V1-full$V1[1]),xlim=c(0,12),pch=1,cex=2,col="blue",lwd=3)
points(seq(1,6,1),c(GV1-GV1[1]),xlim=c(0,12),pch=16,cex=1,lwd=3,col="red")
lines(seq(1,6,1),c(GV1-GV1[1]),lty=3,col="red",lwd=2)
lines(seq(1,6,1),c(full$V1-full$V1[1]),col="blue",lty=3,lwd=2)
legend("bottomright",legend=c('Graph Approach','Z_n Integrals'),cex=2,bg="antiquewhite",pch=c(16,1),col=c('red','blue'),lwd=c(2,2),lty=c(3,3))

dev.off()
