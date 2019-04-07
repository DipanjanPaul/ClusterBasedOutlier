require(corrplot)
require(cluster)
require(useful)
require(Hmisc)
require(plot3D)
library(HSAUR)
library(MVA)
library(HSAUR2)
library(fpc)
library(mclust)
library(lattice)
library(car)

parm <- "none"
setwd("~/Documents/Models/UPS/Dups")

# Main logic starts here
df_tr <- read.csv('agg_data.csv', header=T)
df_tr <- df_tr[complete.cases(df_tr),]

ix <- grep('REVREC', df_tr$tck_nr, fixed=T)
df_tr <- df_tr[-ix,]
ix <- grep('TEST', df_tr$tck_nr, fixed=T)
df_tr <- df_tr[-ix,]
ix <- grep('TOTE', df_tr$tck_nr, fixed=T)
df_tr <- df_tr[-ix,]
ix <- grep('REVRE', df_tr$tck_nr, fixed=T)
df_tr <- df_tr[-ix,]

summary(df_tr)

#df_tr$time_diff_median <- log(df_tr$time_diff_median + 1)

n_data <- df_tr[,-1]
n.data.mean <- apply(n_data, 2, mean)
n.data.sd <- apply(n_data, 2, sd)

n_data <- t((t(n_data)-n.data.mean)/n.data.sd)
which(abs((cor(n_data)) > .5))

p_data <- princomp(n_data)
prob_pca <- round(exp(rowSums(p_data$x[,1:8]))/(1 + exp(rowSums(p_data$x[,1:8]))),4)
  
prob_norm <- round(exp(rowSums(n_data))/(1 + exp(rowSums(n_data))),4)

km_main <- kmeans(n_data, centers=10, nstart=50, iter.max=100)
km_main$betweenss/km_main$totss

dissE <- daisy(n_data)
names(dissE)
dE2   <- dissE^2
sk2   <- silhouette(clusterresults$cluster, dE2)
str(sk2)
plot(sk2)

dup_data <- data.frame(df_tr, km_main$cluster, prob_norm)

table(dup_data$km_main.cluster)
tapply(dup_data$prob_norm, dup_data$km_main.cluster, summary)
#dup_data <- dup_data[(dup_data$prob_norm > (quantile(prob_norm)[4] + 1*sd(prob_norm))),]
#dup_data$time_diff_median <- round((exp(dup_data$time_diff_median) - 1)/3600, 2)

ext <- unlist(tapply(dup_data[,1], dup_data$km_main.cluster, function(x) sample(x,14)))
dt_smp <- dup_data[dup_data$tck_nr %in% unlist(ext),]
dt_all <- dup_data[dup_data$km_main.cluster %in% c(2,3,4),]

write.table(dt_smp,"dup_tck_0312_sample.csv",sep=',',col.names=T,row.names=F)
write.table(dt_all,"dup_tck_0312_all.csv",sep=',',col.names=T,row.names=F)


rm(list=ls())
gc()