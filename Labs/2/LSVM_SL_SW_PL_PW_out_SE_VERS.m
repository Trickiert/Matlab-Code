clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(1:40,1);meas(51:90,1)]; % construct X1 which represents sepal length for training (80 samples)
X2=[meas(1:40,2);meas(51:90,2)]; % construct X2 which represents sepal width for training (80 samples)
X3=[meas(1:40,3);meas(51:90,3)]; % construct X3 which represents petal length for training (80 samples)
X4=[meas(1:40,4);meas(51:90,4)]; % construct X4 which represents petal width for training (80 samples)
input_training_set=[X1,X2,X3,X4]; % The input training set is composed of 80 rows (samples) and four columns (sepal length, sepal width, petal length and petal width)
output_training_set=[species(1:40);species(51:90)]; % construct output data representing two classes (setosa and versicolor) for training (80 samples)


% remember the input training set is composed of X1, X2, X3 and X4
% call the built-in function for the training algorithm (Linear SVM) - See
% Lecture 2
% We assume C1=setosa and C2=versicolor
% If 'showplot' is true, the built-in function svmtrain trains the classifier and then plots the distribution of the classes 
% similar to built-in function gscatter that you have seen in week 1
svmStruct = svmtrain(input_training_set,output_training_set,'Kernel_Function','linear','showplot',false); 


% once the training is performed. The parameters of the classifier can be
% used to predict the class for the input testing set. Let's first calculate
% the classification error on the training set. 

Y_training = svmclassify(svmStruct,input_training_set,'showplot',false);  % compute the output of the classifier

bad = ~strcmp(Y_training,output_training_set); % compare the output of the classifier with the actual classes (training set)
error_training = sum(bad) / length(X1); % calculate training error
disp('Training error is '), error_training


%*** testing *****************************

% Now, we can measure the performance of the classifier on the
% test set. 
X1_testing=[meas(41:50,1);meas(91:100,1)]; % construct X1 which represents sepal length for the testing (20 samples)
X2_testing=[meas(41:50,2);meas(91:100,2)]; % construct X2 which represents sepal width for the testing (20 samples)
X3_testing=[meas(41:50,3);meas(91:100,3)]; % construct X3 which represents petal length for the testing (20 samples)
X4_testing=[meas(41:50,4);meas(91:100,4)]; % construct X4 which represents petal width for the testing (20 samples)
input_testing_set=[X1_testing,X2_testing,X3_testing,X4_testing]; % The input testing set is composed of 20 rows (samples) and four columns (sepal length, sepal width, petal length and petal width)
output_testing_set=[species(41:50);species(91:100)]; % construct output data representing two classes (setosa and versicolor) for testing (20 samples)

Y_testing = svmclassify(svmStruct,input_testing_set,'showplot',false);  % compute the output of the classifier

bad = ~strcmp(Y_testing,output_testing_set); % compare the output of the classifier with the actual classes (testing set)
error_testing = sum(bad) / length(X1_testing); % calculate testing error
disp('Testing error is '), error_testing