library(caret)
variableRanking<-function(x, y, method = c("nnet","rpart","gbm","blackboost",
                                           "glmboost","gamboost","treebag","pls","lm",
                                           "svmRadial","svmPoly","gaussprRadial","gaussprPoly","lasso",
                                           "rf","mars","enet","rvmRadial","rvmPoly","lda","multinom","rda",
                                           "fda","sddaLDA","sddaQDA","bagEarth","ctree","cforest",
                                           "nb","gpls","lvq"),
                          plot=F, ...)
{
  #Resetting an error flag
  errFlag<-0
  
  #Get the method argument in the function
  methodType<-match.arg(method)
  
  if(methodType == "mars")
  {
    methodType<-"earth"
  }
  
  tryCatch({
    modelFit<-train(x,y,method=methodType,...)
    varImportance<-varImp(modelFit)
  },error=function(e)
  {
    #message("The error is:")
    #message(e)
    errFlag<<-1
  })
  if(errFlag==1)
  {
    #message("The Tuning Parameters for the model are not set properly or the dataset provided is not proper. Please refer to the caret package and the specific model packages for details")
    return()
  }
  
  #Check for plotting a dotchart
  if(plot)
  {
    modProfile<-varImportance$importance
    featureVec<-modProfile[order(modProfile[,1],decreasing=T),1]
    names(featureVec)<-row.names(modProfile)[order(modProfile[,1],decreasing=T)]
    par(mgp=c(0.3,1.3,0))
    dotchart(rev(featureVec), cex = 0.4, main = "Variable Ranking values")
  } 
  #Return the importance values of the features in order of importance
  return(varImportance)
}

v<-variableRanking(x, y, "nb")
