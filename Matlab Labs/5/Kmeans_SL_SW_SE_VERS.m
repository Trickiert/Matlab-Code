clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(1:40,1);meas(51:90,1)]; % construct X1 which represents sepal length (80 samples)
X2=[meas(1:40,2);meas(51:90,2)]; % construct X2 which represents sepal width (80 samples)
Pattern_set=[X1,X2]; % The set of patterns is composed of 80 rows (samples) and two columns (sepal length and sepal width)
Actual_clusters_set=[species(1:40);species(51:90)]; % construct the set which represents the actual clusters (setosa and versicolor)  (80 samples)


rng('default'); % set the random number generator to its default state
rng(13); % this is an integer value to initialise the random number generator

idx = kmeans(Pattern_set,2); % apply k-means to group the samples of Pattern_set in two clusters. 
% Observe that the k-means clustering method does not use the target output
% set (unsupervised learning).
%The output idx gives the index of each row in Pattern_set. Becasue k-means
%method uses two clusters, the values in idx will be either 1 or 2.

% display the input samples as grouped in two clusters by k-means
figure,plot(Pattern_set(idx==1,1),Pattern_set(idx==1,2),'b.','MarkerSize',16)
hold on, plot(Pattern_set(idx==2,1),Pattern_set(idx==2,2),'r.','MarkerSize',16)
legend('Cluster 1','Cluster 2'), title('k-means clusters')

% display the input samples as grouped in two classes by experts on iris plants (actual
% clusters)
figure,gscatter(Pattern_set(:,1), Pattern_set(:,2), Actual_clusters_set,'gb','so');  xlabel('Sepal length');
ylabel('Sepal width'); title('actual clusters');
