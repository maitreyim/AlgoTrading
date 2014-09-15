####### Factor Analysis of ETFs#######
data<-read.csv("FA_IB.csv")
f1<-cor(data)
write.table(f1,"cor.csv",sep=",")

total<-total[,c(-1)]

fit <- factanal(total, 3, rotation="varimax")