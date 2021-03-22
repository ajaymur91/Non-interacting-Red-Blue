
suppressMessages(library(igraph))
suppressMessages(library(dplyr))

#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)<2) {
  stop("At least 2 arguments must be supplied: Eg) Rscript Graph_NI.R <N_particles> <Number of insertions per config>", call.=FALSE)
} else if (length(args)==2) {
  # default output file
  args[3] = "out.txt"
}

# Number of particles in box
Np <- as.integer(args[1]) 

# Number of particles to insert (Currently works ony for 2)
Ng <- 2
Np2 <- Np+Ng

# Number of insertions per config
Nt <- as.double(args[2])

#Nro <- 10000
# FR - Size of the Resampled config - (can be > 1 too,.. equiv to new insertions) 
FR <- Nt

# Read cluster configurations of size Np
 X <- as.matrix(read.table(paste0('./FE',Np,'/X')))
 Y <- as.matrix(read.table(paste0('./FE',Np,'/Y')))
 Z <- as.matrix(read.table(paste0('./FE',Np,'/Z')))

 # Resample from configurations (For code testing mostly)
 # If FR > 1 - this is (approx) equivalent to multiple insertions per config 
 frac <- FR
 X <- as.matrix(sample_frac(data.frame(X),frac,replace = TRUE))
 Y <- as.matrix(sample_frac(data.frame(Y),frac,replace = TRUE))
 Z <- as.matrix(sample_frac(data.frame(Z),frac,replace = TRUE))
 rownames(X)<-NULL
 rownames(Y)<-NULL
 rownames(Z)<-NULL

Ns <- length(X[,1]) # Ns configurations
Ld <- 0.35 # Connected if distance less than Ld

##########################
# Adjacency correction factor (Acf)
# AdjM_true <- Argon-like-AdjM ** Acf
# i.e. Cation-cation connections have to be neglected
# i.e. anion-anion connections have to be neglected
dim <- Np
AcfN <- matrix(rep(1,dim*dim), nrow = dim, ncol = dim)
for(i in seq(1,dim,1)){
  for(j in seq(1,dim,1)){
    if((i+j) %% 2==0) { AcfN[i,j]=0 }
  }
}

dim <- Np2
AcfNp1 <- matrix(rep(1,dim*dim), nrow = dim, ncol = dim)
for(i in seq(1,dim,1)){
  for(j in seq(1,dim,1)){
    if((i+j) %% 2==0) { AcfNp1[i,j]=0 }
  }
}
################################################
# Function to find if cluster is connected
isconN <- function(X,Y,Z,Ld) {
  dist(cbind(X,Y,Z),method = "euclidian")
  # Calc adj matrix
  AdjM <- 1*(as.matrix(dist(cbind(X,Y,Z),method = "euclidian"))<Ld) * AcfN
  # Convert to graph
  G <- graph_from_adjacency_matrix(AdjM,mode = "undirected",diag = FALSE)
  # Check connected
  return(1*(is_connected(G)))
}

isconNp1 <- function(X,Y,Z,Ld) {
  # Calc adj matrix
  AdjM <- 1*(as.matrix(dist(cbind(X,Y,Z),method = "euclidian"))<Ld) * AcfNp1
  # Convert to graph
  G <- graph_from_adjacency_matrix(AdjM,mode = "undirected",diag = FALSE)
  # Check connected
  return(1*(is_connected(G)))
}

################################################
# Generate positions for 2 new partcles (for Ns configurations)
GX <- matrix(runif(Ns*Ng), ncol = Ng)
GY <- matrix(runif(Ns*Ng), ncol = Ng)
GZ <- matrix(runif(Ns*Ng), ncol = Ng)

# Combine new particles with configurations to create cluster of size (N+1)
X2 <- cbind(X,GX)
Y2 <- cbind(Y,GY)
Z2 <- cbind(Z,GZ)
################################################
# Save Connectivity for each configuration in a vector: C
C <- rep(0,Ns)
k <- 1
#I th configuration
for(i in seq(1,Ns,1)){
    C[k] <-  isconNp1(X2[i,],Y2[i,],Z2[i,],Ld) 
    k <- k+1
}
C3 <- C
################################################
# Mratio calculations
# Read cluster configurations of size (N+1)
X <- as.matrix(read.table(paste0('./FE',Np2,'/X')))
Y <- as.matrix(read.table(paste0('./FE',Np2,'/Y')))
Z <- as.matrix(read.table(paste0('./FE',Np2,'/Z')))
frac <- FR
X <- as.matrix(sample_frac(data.frame(X),frac,replace = TRUE))
Y <- as.matrix(sample_frac(data.frame(Y),frac,replace = TRUE))
Z <- as.matrix(sample_frac(data.frame(Z),frac,replace = TRUE))
rownames(X)<-NULL
rownames(Y)<-NULL
rownames(Z)<-NULL
################################################
Ns <- length(X[,1]) # Ns configurations of size (N+1)
#Nc <- 0   # Counter for number of connected
Ld <- 0.35 # Connected if distance less than Ld

if(Np2 %% 2 == 0){
C <- rep(0,Ns*(Np2/2)*(Np2/2))
k <- 1

#I th configuration
for(i in seq(1,Ns,1)){
  for (j in seq(2,Np2,2)){
	  for(l in seq(1,Np2-1,2)){
    C[k] <-  isconN(X[i,c(-j,-l)],Y[i,c(-j,-l)],Z[i,c(-j,-l)],Ld) 
    k <- k+1
	}
  }
}
C4 <- C
}

# Print results
#print(-log((sum(C3)/length(C3))*(length(C4)/sum(C4))))
#print(-log((sum(C3)/length(C3))))
#print(-log((length(C4)/sum(C4))))

################################################
# Bootstrapping for error analysis
Nb <- 100
FE <- rep(0,Nb)
# Also Resamples are with replacement
frac <- 1
for(i in seq(1,Nb,1)){
  # Resample
  S3 <- sample_frac(data.frame(C3),frac,replace = TRUE)$C3
  S4 <- sample_frac(data.frame(C4),frac,replace = TRUE)$C4
  FE[i] <- (-log((sum(S3)/length(S3))*(length(S4)/sum(S4))))
}
# Store results and error bars 
Stats <- cbind(mean(FE),max(FE),min(FE))
Stats
write.table(Stats,file = paste0('./FE',Np,'/Stats_graph'),row.names = F) #,col.names = c("mean","max","min"))
################################################