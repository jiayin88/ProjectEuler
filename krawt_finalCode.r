#task:
#1. get image
#2. normalize image
#3. resize image
#4. do histeq on image
#5. perform moment method
#6. vectorize the result
#7. rename column
#8. remove all with variance = 0
#9. save result


#options(error=recover)
start <- Sys.time()

library(parallel)
library(png)

wdname <- "/home/vicenza/work/imsize_300/"
resultFolder <- "/home/vicenza/work/exp_imsize_300/"
n <- 163 #moment order
x <- 300 #image width
y <- 300 #image height

getKrawt <- function(img,n){
	img <- histeq(img)
	obj <- momentObj(img,type='krawt',order=n,0.5)
	obj
}

# Use the detectCores() function to find the number of cores in system
no_cores <- detectCores() - 2
 
# Setup cluster
clust <- makeCluster(no_cores) #This line will take time

clusterEvalQ(clust, {
 library(IM)
})

library(EBImage)

getImage <- function(file,x,y){
	im <- resize(file,x,y)
	normalize(file)
}

setwd(wdname)

file <- list.files()
wdname <- getwd()

#read and resize image to 300x300
sf <- lapply(file,readPNG)
subfile <- lapply(sf,getImage,x,y)

#obtain Krawtchouk moment
krawt <- parLapply(clust,subfile,getKrawt,n)
names(krawt) <- file

#extract Krawtchouk moment and convert it to a table of features. All features that have the same values are removed.
kw <- lapply(krawt,function(x)as.vector(x@moments))
kw1 <- do.call(rbind,kw)
colnames(kw1) <- paste("K",1:ncol(kw1),sep="")
kw1var <- apply(kw1,2,var)

if(length(which(kw1var==0))!=0){
	n <- which(kw1var==0)
	kw1 <- kw1[,-n]
}

#save result
newfilename <- paste(resultFolder,"krawt_p0_resize_x",x,"y",y,".txt",sep="")
write.table(kw1,newfilename)

stopCluster(clust)
fin <- Sys.time()
print(paste((fin - start),start,fin,sep=" AND "))
#debugger()
