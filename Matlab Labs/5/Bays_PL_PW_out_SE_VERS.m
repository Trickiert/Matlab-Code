clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(1:40,3);meas(51:90,3)]; % construct X1 which represents petal length for training (80 samples)
X2=[meas(1:40,4);meas(51:90,4)]; % construct X2 which represents petal width for training (80 samples)
input_training_set=[X1,X2]; % The input training set is composed of 80 rows (samples) and two columns (petal length and petal width)
output_training_set=[species(1:40);species(51:90)]; % construct output data representing two classes (setosa and versicolor) for training (80 samples)


% remember the input training set is composed of X1 and X2
classifier = NaiveBayes.fit(input_training_set,output_training_set); % build a classification tree using the training samples
disp(classifier);  % show classifier

% once the training is performed. The tree can be
% used to predict the class for the input testing set.  Let's first calculate
% the classification error on the training set. 

Y_training = classifier.predict(input_training_set);  % compute the output of the classifier

bad = ~strcmp(Y_training,output_training_set); % compare the output of the classifier with the actual classes (training set)
error_training = sum(bad) / length(X1); % calculate training error
disp('Training error is '), error_training


%*** testing *****************************

% Now, we can measure the performance of the classifier on the
% test set. 
X1_testing=[meas(41:50,3);meas(91:100,3)]; % construct X1 which represents petal length for the testing (20 samples)
X2_testing=[meas(41:50,4);meas(91:100,4)]; % construct X2 which represents petal width for the testing (20 samples)
input_testing_set=[X1_testing,X2_testing]; % The input testing set is composed of 20 rows (samples) and two columns (petal length and petal width)
output_testing_set=[species(41:50);species(91:100)]; % construct output data representing two classes (setosa and versicolor) for testing (20 samples)

Y_testing = classifier.predict(input_testing_set);  % compute the output of the classifier

bad = ~strcmp(Y_testing,output_testing_set); % compare the output of the classifier with the actual classes (testing set)
error_testing = sum(bad) / length(X1_testing); % calculate testing error
disp('Testing error is '), error_testing
