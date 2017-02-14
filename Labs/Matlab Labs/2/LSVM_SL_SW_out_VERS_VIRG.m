clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(51:90,1);meas(101:140,1)]; % construct X1 which represents sepal length for training (80 samples)
X2=[meas(51:90,2);meas(101:140,2)]; % construct X2 which represents sepal width for training (80 samples)
input_training_set=[X1,X2]; % The input training set is composed of 80 rows (samples) and two columns (sepal length and sepal width)
output_training_set=[species(51:90);species(101:140)]; % construct output data representing two classes (versicolor and virginica) for training (80 samples)


% remember the input training set is composed of X1 and X2
% call the built-in function for the training algorithm (Linear SVM) - See
% Lecture 2
% We assume C1=setosa and C2=versicolor
% If 'showplot' is true, the built-in function svmtrain trains the classifier and then plots the distribution of the classes 
% similar to built-in function gscatter that you have seen in week 1
svmStruct = svmtrain(input_training_set,output_training_set,'Kernel_Function','linear','showplot',true); 
xlabel('Sepal length'); % add label for horizontal axis
ylabel('Sepal width');   % add label for the vertical axis

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
X1_testing=[meas(91:100,1);meas(141:150,1)]; % construct X1 which represents sepal length for the testing (20 samples)
X2_testing=[meas(141:150,2);meas(141:150,2)]; % construct X2 which represents sepal width for the testing (20 samples)
input_testing_set=[X1_testing,X2_testing]; % The input testing set is composed of 20 rows (samples) and two columns (sepal length and sepal width)
output_testing_set=[species(91:100);species(141:150)]; % construct output data representing two classes (versicolor and virginica) for testing (20 samples)
Y_testing = svmclassify(svmStruct,input_testing_set,'showplot',false);  % compute the output of the classifier

bad = ~strcmp(Y_testing,output_testing_set); % compare the output of the classifier with the actual classes (testing set)
error_testing = sum(bad) / length(X1_testing); % calculate testing error
disp('Testing error is '), error_testing