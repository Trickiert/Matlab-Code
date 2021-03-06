clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(51:90,1);meas(101:140,1)]; % construct X1 which represents sepal length for training (80 samples)
X2=[meas(51:90,2);meas(101:140,2)]; % construct X2 which represents sepal width for training (80 samples)
X3=[meas(51:90,3);meas(101:140,3)]; % construct X3 which represents petal length for training (80 samples)
X4=[meas(51:90,4);meas(101:140,4)]; % construct X4 which represents petal width for training (80 samples)
input_training_set=[X1';X2';X3';X4']; % The input training set is composed of 80 columns (samples) and four rows (sepal length, sepal width, petal length, and petal width)
output_training_set=[species(51:90)',species(101:140)']; % construct output data representing two classes (versicolor and virginica) for training (80 samples)

% remember the input training set is composed of X1,X2, X3, and X4
% call the built-in function for the training algorithm (Linear neuron- perceptron) - See
% Lecture 2
% We assume C1=versicolor and C2=virginica
% convert output training set into ones (for versicolor) and zeros (for
% virginica)
Target=strcmp('versicolor',output_training_set); % Now, Target has logical values (0 and 1). This has to be converted into double.
perceptron = newp(input_training_set,double(Target)); % create a perceptron (single neuron) for linear classification
perceptron.trainParam.epochs = 40;  % set to 40 the number of times the training samples will be used to train the perceptron
perceptron = train(perceptron,input_training_set,double(Target)); % train the perceptron with the training samples.


% once the training is performed. The perceptron can be
% used to predict the class for the input testing set. Let's first calculate
% the classification error on the training set. 

Y_training= sim(perceptron,input_training_set);  % compute the output of the trained perceptron

bad = (Y_training~=double(Target)); % compare the output of the trained perceptron with the actual classes (Target)
error_training = sum(bad) / length(X1); % calculate the training error
disp('Training error is '), error_training


%*** testing *****************************

% Now, we can measure the performance of the classifier on the
% test set. 
X1_testing=[meas(91:100,1);meas(141:150,1)]; % construct X1 which represents sepal length for the testing (20 samples)
X2_testing=[meas(141:150,2);meas(141:150,2)]; % construct X2 which represents sepal width for the testing (20 samples)
X3_testing=[meas(41:50,3);meas(91:100,3)]; % construct X3 which represents petal length for the testing (20 samples)
X4_testing=[meas(41:50,4);meas(91:100,4)]; % construct X4 which represents petal width for the testing (20 samples)
input_testing_set=[X1_testing';X2_testing';X3_testing';X4_testing']; % The input testing set is composed of 20 columns (samples) and four rows (sepal length, sepal width, petal length, and petal width)
output_testing_set=[species(91:100)',species(141:150)']; % construct output data representing two classes (versicolor and virginica) for testing (20 samples)

%convert output testing set into ones (for versicolor) and zeros (for virginica)
output=strcmp('versicolor',output_testing_set); % Now, output has logical values (0 and 1). This has to be converted into double.
Y_testing = sim(perceptron,input_testing_set);  % compute the output of the trained perceptron

bad = (Y_testing~=double(output)); % compare the output of the classifier with the actual classes (testing set)
error_testing = sum(bad) / length(X1_testing); % calculate testing error
disp('Testing error is '), error_testing