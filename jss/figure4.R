library("R.matlab")
library("glmnet")

a <- readMat("jssfigure4.mat")
if (a$standardize) {
   print("Standardized")
}
if (a$intercept) {
   print("Intercept")
}
x <- proc.time()
fit = glmnet(a$X,a$y,family=a$type,standardize=a$standardize,intercept=a$intercept,alpha=a$alpha,nlambda=a$nlambda)
t <- proc.time()-x

if (is.list(fit$beta)) {
   print("is a list")
   b<-as(fit$beta[[1]],"matrix")
   for (i in 2:length(fit$beta)) {
      b <- rbind(b,as(fit$beta[[i]],"matrix"))
   }
   fit$beta <- b
} else {
   print("not a list")
}
  
writeMat("jssfigure4out.mat",a0=fit$a0, beta=fit$beta, dev=fit$dev.ratio,
 df=fit$df, lambda=fit$lambda, nulldev=fit$nulldev, elapsed=t )