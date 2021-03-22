#!/usr/bin/env Rscript
# Load libraries
suppressMessages(library(igraph))
suppressMessages(library(dplyr))

################ Read Command line inputs ###########
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)<2) {
  stop("At least 2 arguments must be supplied (input file).n", call.=FALSE)
} 
############### Inputs #########################
Ns <- as.integer(args[1])   # Generate Ns configurations
Np <- as.integer(args[2])   # Np particles in Box
Ld <- 0.35 # Connected if distance less than Ld
Ncopy <- as.integer(args[3])   # Ncopy
#Nc <- 0   # Counter for number of connected
################################################
# Generate random Ns configurations for Np particles
X <- matrix(runif(Ns*Np), ncol = Np)
Y <- matrix(runif(Ns*Np), ncol = Np)
Z <- matrix(runif(Ns*Np), ncol = Np)
################################################
# Adjacency correction factor (Acf)
# AdjM_true <- Argon-like-AdjM ** Acf
# i.e. Cation-cation connections have to be neglected
# i.e. anion-anion connections have to be neglected
dim <- Np
Acf <- matrix(rep(1,dim*dim), nrow = dim, ncol = dim)
for(i in seq(1,dim,1)){
            for(j in seq(1,dim,1)){
                          if((i+j) %% 2==0) { Acf[i,j]=0 }
                                      }
                            }
################################################

# Function to find if cluster is connected
iscon <- function(X,Y,Z,Ld) {
  Dim <- length(X)
  # Calc adj matrix (Notice Acf factor)
  AdjM <- 1*(as.matrix(dist(cbind(X,Y,Z),method = "euclidian"))<Ld) * Acf
  # Convert to graph
  G <- graph_from_adjacency_matrix(AdjM,mode = "undirected",diag = FALSE)
  # Check connected
  return(1*(is_connected(G)))
}
################################################

# Save Connectivity for each configuration in a vector: C
C <- rep(0,Ns)
#I th configuration
for(i in seq(1,Ns,1)){
C[i] <-  iscon(X[i,],Y[i,],Z[i,],Ld)
}

################################################
# Bootstrapping for error analysis
Nb <- 100
FE <- rep(0,Nb)
# Also Resample are with replacement
frac <- 1
for(i in seq(1,Nb,1)){
# Find length of sample for 10% of the data
S <- sample_frac(data.frame(C),frac,replace = TRUE)
Zint <- sum(S)/Ns
FE[i] <- -log(Zint)
}
# Store results and error bars 
Stats <- cbind(mean(FE),max(FE),min(FE))
write.table(Stats,file = paste0('./FE',Np,'/Stats',Ncopy),row.names = F,col.names = c("mean","max","min"))
#write.table(c(Ns,sum(C),mean(FE)),file = paste0('./FE',Np,'/out.txt'),row.names = F)#,col.names = c("N_attempt","N_success","FE"))
################################################
# Save connected cluster (for graph based analysis)
IND <- which(C==1)
write.table(X[IND,],file = paste0('./FE',Np,'/X',Ncopy))
write.table(Y[IND,],file = paste0('./FE',Np,'/Y',Ncopy))
write.table(Z[IND,],file = paste0('./FE',Np,'/Z',Ncopy))
################################################
