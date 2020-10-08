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

wdname <- "/home/vicenza/work/mias-roi/"
resultFolder <- "/home/vicenza/work/newres/"
newfilename <- paste(resultFolder,"mias-roi-gpzm_p50_resize_x",x,"y",y,".txt",sep="")

p <- 0 #alpha
n <- 126 #order
x <- 300 #image width
y <- 300 #image height

getZernike <- function(img,p,n){
	img <- histeq(img)
	obj<- new("CmplxIm", img=img)
	#set the moment type to generalized Pseudo-Zernike
	momentType(obj)<- "gpzm"
	obj@centroid <- dim(img)/2
	#set the order
	setOrder(obj)<- n
	#set the parameter  
	setParams(obj)<- p
	#calculate moments of the image
	Moments(obj)<- NULL
	#calculate rotation invariants
	Invariant(obj) = NULL;
	#reconstruct the image from moments
	Reconstruct(obj) <- dim(img)
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
	normalize(im)
}

setwd(wdname)

file <- list.files()
wdname <- getwd()

#read and resize image to 300x300
sf <- lapply(file,readPNG)
subfile <- lapply(sf,getImage,x,y)

#obtain GPZM moment
zernike <- parLapply(clust,subfile,getZernike,p,n)
names(zernike) <- file

#extract GPZM moment invariant and convert it to a table of features. All features that have the same values are removed.
zn <- lapply(zernike,function(x)as.vector(x@invariant))
zn1 <- do.call(rbind,zn)
colnames(zn1) <- paste("Z",1:ncol(zn1),sep="")
zn1var <- apply(zn1,2,var)

if(length(which(zn1var==0))!=0){
	n <- which(zn1var==0)
	zn1 <- zn1[,-n]
}

#save result
write.table(zn1,newfilename)

stopCluster(clust)
fin <- Sys.time()
print(paste((fin - start),start,fin,sep=" AND "))
#debugger()
