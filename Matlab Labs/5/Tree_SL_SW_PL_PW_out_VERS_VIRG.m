clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(51:90,1);meas(101:140,1)]; % construct X1 which represents sepal length for training (80 samples)
X2=[meas(51:90,2);meas(101:140,2)]; % construct X2 which represents sepal width for training (80 samples)
X3=[meas(51:90,3);meas(101:140,3)]; % construct X3 which represents petal length for training (80 samples)
X4=[meas(51:90,4);meas(101:140,4)]; % construct X4 which represents petal width for training (80 samples)
input_training_set=[X1,X2,X3,X4]; % The input training set is composed of 80 rows (samples) and four columns (sepal length, sepal width, petal length, and petal width)
output_training_set=[species(51:90);species(101:140)]; % construct output data representing two classes (versicolor and virginica) for training (80 samples)

% remember the input training set is composed of X1, X2, X3 and X4
t = classregtree(input_training_set, output_training_set); % build a classification tree using the training samples
view(t);  % show the trained tree

% once the training is performed. The tree can be
% used to predict the class for the input testing set.  Let's first calculate
% the classification error on the training set. 

Y_training = eval(t,input_training_set);  % compute the output of the classifier

bad = ~strcmp(Y_training,output_training_set); % compare the output of the classifier with the actual classes (training set)
error_training = sum(bad) / length(X1); % calculate training error
disp('Training error is '), error_training


%*** testing *****************************

% Now, we can measure the performance of the classifier on the
% test set. 
X1_testing=[meas(91:100,1);meas(141:150,1)]; % construct X1 which represents sepal length for the testing (20 samples)
X2_testing=[meas(141:150,2);meas(141:150,2)]; % construct X2 which represents sepal width for the testing (20 samples)
X3_testing=[meas(41:50,3);meas(91:100,3)]; % construct X3 which represents petal length for the testing (20 samples)
X4_testing=[meas(41:50,4);meas(91:100,4)]; % construct X4 which represents petal width for the testing (20 samples)
input_testing_set=[X1_testing,X2_testing,X3_testing,X4_testing]; % The input testing set is composed of 20 rows (samples) and four columns (sepal length, sepal width, petal length, and petal width)
output_testing_set=[species(91:100);species(141:150)]; % construct output data representing two classes (versicolor and virginica) for testing (20 samples)

Y_testing = eval(t,input_testing_set);  % compute the output of the classifier

bad = ~strcmp(Y_testing,output_testing_set); % compare the output of the classifier with the actual classes (testing set)
error_testing = sum(bad) / length(X1_testing); % calculate testing error
disp('Testing error is '), error_testing