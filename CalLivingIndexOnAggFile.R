#R Script to normalized and calculate Living index and write it to new File
library(clusterSim)
aggFile <- read.csv(file="C:/Users/Mangesh/Documents/app/op_LI_Kmeans.csv",head=TRUE,sep=",")
# data Normalization in range of -1 to +1
aggFileNorm <- data.Normalization (aggFile[,4:12],type="n5",normalization="column")
aggFile[,4:12] <- aggFileNorm
head(aggFile)
Living_Index_Updated <- NULL
rows <- nrow(aggFile)

for (i in 1:rows){
cat(" Working on Record:",i)
  Living_Index_Updated[i] <- ((-aggFile[i:i,4:4]) + ((-aggFile[i:i,5:5])) + ((-aggFile[i:i,6:6])) + (-aggFile[i:i,7:7]) + (-aggFile[i:i,8:8]) + (aggFile[i:i,9:9]) +(aggFile[i:i,10:10]) + (aggFile[i:i,11:11]))
}

#aggFile <- read.csv(file="C:/Users/Mangesh/Documents/app/op_LI_Kmeans.csv",head=TRUE,sep=",")
aggFile$Living_Index <- Living_Index_Updated

write.table(aggFile, file="C:/Users/Mangesh/Documents/app/op_LI_KmeansUpdated.csv", row.names=FALSE, sep=",")
