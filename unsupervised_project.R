#Load dataset
library(here)
data<-read.csv(here("MaunaLoa.csv"))

#Nature and characteristics of each variable
str(data)

#Libraries
library(corrplot)

#check na or missing values
sum(is.na(data))
#No missing values found

#Pair plot
#install.packages('psych')
library(psych)
pairs.panels(data[,-1], main="Pairs Plot of all the gases with outliers (Fig.C)")

#Identify outliers
boxplot(data[,2:6])
outliers<-boxplot(data[,2:6])$out
outlier_rows <- data[rowSums(apply(data[, 2:6], 2, function(x) x %in% outliers)) > 0, ]
print(outlier_rows)

#Time series graph
library(ggplot2)
mauna_loa_data<-data
mauna_loa_data$Date <- as.Date(mauna_loa_data$Date)#convert chr to num values
gas_names <- names(mauna_loa_data)[-1]# Get the list of all variable names except 'Date'
melted_data <- reshape2::melt(mauna_loa_data, id.vars = "Date")# Melt the data for easy plotting

#Plot graph
ggplot(data = melted_data, aes(x = Date, y = value, color = variable)) +
  geom_line() +
  geom_point() +
  geom_smooth(method = "loess", se = FALSE, span = 0.75, color = "black") +  
  labs(x = "Date", y = "Value", title = "Time Series Plot of concentration of all gases by years ") +
  facet_wrap(~ variable, scales = "free_y")


#Pair plot after removing outliers
#install.packages('psych')
library(psych)
clean_data<-data[-c(131:135),]
pairs.panels(clean_data[,-1], main = "Pairs Plot of all the gases without outliers (Fig.F)")

#Following are the operations applied in the dimensionality reduction 
#Dimensionality Reduction using prcomp function
pr.out<-prcomp(clean_data[,-1], scale = TRUE)
names(pr.out)
summary(pr.out)
pr.out$rotation

#Calculate dot products of PC (Pairwise Orthogonal)
PC <- function(i){pr.out$rotation[,i]}
PC(1)%*%PC(2)
PC(1)%*%PC(1)
PC(3)%*%PC(3)
PC(4)%*%PC(4)
PC(5)%*%PC(5)

#Calculate Measure importance
pr.var<-pr.out$sdev^2
pr.var
sum(pr.var)

#Plotting Screeplot
library(factoextra)
fviz_screeplot(pr.out, addlabels = TRUE, linecolor = 'red',
main = 'Scree plot of the proportion of variance explained by the new variables')

#Plot autolot
library(ggfortify)
autoplot(pr.out, data = clean_data[,-1], loadings = TRUE,
         loadings.col = 'blue',loadings.label = TRUE,
         loadings.label.size = 3) 



#Contribution of Variables to Dim-1 and Dim-2
fviz_contrib(pr.out, choice = "var", axes = 1, top = 10)
fviz_contrib(pr.out, choice = "var", axes = 2, top = 10)
get_pca_var(pr.out)$cor
get_pca_var(pr.out)$cos2
get_pca_var(pr.out)$contrib

#Plot
plot(pr.out, col ='steelblue', main = 'Importance of Mauna Loa PC')
lines(x =1:5, pr.var, type = 'b', pch = 19, col = 'red')

pr.out$x
summary(pr.out$x)
pairs.panels(pr.out$x)



                                                       



#cluster
cluster_data<-clean_data
cluster.scaled<-scale(cluster_data[,-1])

#Select no. of clusters
library(ggplot2)
library(factoextra)
fviz_nbclust(cluster.scaled, kmeans, method = 'wss')

#compute k means
set.seed(123)
km.res<-kmeans(cluster.scaled, 3, nstart = 25)
names(km.res)
km.res

#Aggregate Function
aggregate(scale(cluster_data[,-1]),by = list(cluster = km.res$cluster), mean)

#Assign
table(cluster_data$Date, km.res$cluster)

cluster_data$Date <- as.Date(cluster_data$Date)

#Load the lubridate package
#install.packages('lubridate')
library(lubridate)

# Extract the year component from the Date column
cluster_data$Year <- year(cluster_data$Date)

# Assuming km.res$cluster contains the cluster assignments
# Create a table with Year and Cluster assignments
cluster_table <- table(cluster_data$Year, km.res$cluster)

#Display the table
print(cluster_table)

#Plot cluster plot
fviz_cluster(km.res,cluster_data[,-1], ellipse.type = "norm",
main = "K-means Cluster Plot")


#Medoids

library(cluster)
pam.res<-clara(cluster.scaled, k = 3)
names(pam.res)
pam.res$medoids
pam.res$i.med
pam.res$clustering
table(cluster_data$Year, pam.res$clustering)

#Select no. of clusters
library(factoextra)
fviz_nbclust(cluster.scaled, clara, method = 'wss')
fviz_cluster(pam.res,cluster.scaled, ellipse.type = "norm",
main = "K-medoids Cluster Plot")

#Silhouette measures
fviz_nbclust(cluster.scaled, kmeans, method = "silhouette")+
  labs(title = "Silhouette measure K-means")
fviz_nbclust(cluster.scaled, clara, method = "silhouette")+
  labs(title = "Silhouette measure K-medoids")
fviz_nbclust(cluster.scaled, hcut, method = "silhouette")+
  labs(title = "Hierarchical")

#Select no. of clusters with Silhouette width
#kmeans
kmeans_model <- kmeans(cluster.scaled, centers = 3)
sil_widths <- silhouette(kmeans_model$cluster, dist(cluster.scaled))
fviz_silhouette(sil_widths) + 
  labs(title = paste("Silhouette Analysis for", 3, "Clusters (K-means)"))

#kmediods
pam_model <- clara(cluster.scaled, k = 3)
sil_widths <- silhouette(pam_model$clustering, dist(cluster.scaled))
fviz_silhouette(sil_widths) + 
  labs(title = paste("Silhouette Analysis for", 3, "Clusters (K-medoids)"))

#hirarchical
hierarchical_model <- hclust(dist(cluster.scaled))
cut_tree <- cutree(hierarchical_model, k = 3)
sil_widths <- silhouette(cut_tree, dist(cluster.scaled))
fviz_silhouette(sil_widths) + 
  labs(title = paste("Silhouette Analysis for", 3, "Clusters (Hierarchical)"))
  
