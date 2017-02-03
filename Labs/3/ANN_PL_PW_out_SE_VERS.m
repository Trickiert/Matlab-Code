clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(1:40,3);meas(51:90,3)]; % construct X1 which represents petal length for training (80 samples)
X2=[meas(1:40,4);meas(51:90,4)]; % construct X2 which represents petal width for training (80 samples)
input_training_set=[X1';X2']; % The input training set is composed of 80 columns (samples) and two rows (petal length and petal width)
output_training_set=[species(1:40)',species(51:90)']; % construct output data representing two classes (setosa and versicolor) for training (80 samples)

% remember the input training set is composed of X1 and X2
% call the built-in function for the training algorithm (non-linear neural netwrok) - See
% Lecture 3
% We assume C1=setosa and C2=versicolor
% convert output training set into ones (for setosa) and zeros (for
% versicoor)
Target=strcmp('setosa',output_training_set); % Now, Target has logical values (0 and 1). This has to be converted into double.

rng('default'); % set the random number generator to its default state
rng(13); % this is an integer value to initialise the random number generator

net = newpr(input_training_set,double(Target),[10 5]); % create a network for non-linear classification, 10 neurons in first hidden layer 
% and 5 in the second.
net.layers{1}.transferFcn='tansig';  % transfer function for the neurons in first hidden layer is tangent sigmoid.
net.layers{2}.transferFcn='tansig';  % transfer function for the neurons in second hidden layer is tangent sigmoid.
net.layers{3}.transferFcn='purelin';  % transfer function for the neurons in the output layer is linear.
net.trainParam.epochs = 40;  % set to 40 the number of times the training samples will be used to train the network
net = train(net,input_training_set,double(Target)); % train the network with the training samples.
% once the training is performed. The network can be
% used to predict the class for the input testing set. Let's first calculate
% the classification error on the training set. 

Y_training= sim(net,input_training_set);  % compute the output of the trained network

bad = (round(Y_training)~=double(Target));% compare the output (rounded to the closest 0 or 1) of the trained network with the actual classes (Target)
error_training = sum(bad) / length(X1); % calculate the training error
disp('Training error is '), error_training


%*** testing *****************************

% Now, we can measure the performance of the network on the
% test set. 
X1_testing=[meas(41:50,3);meas(91:100,3)]; % construct X1 which represents petal length for the testing (20 samples)
X2_testing=[meas(41:50,4);meas(91:100,4)]; % construct X2 which represents petal width for the testing (20 samples)
input_testing_set=[X1_testing';X2_testing']; % The input testing set is composed of 20 columns (samples) and two rows (petal length and petal width)
output_testing_set=[species(41:50)',species(91:100)']; % construct output data representing two classes (setosa and versicolor) for testing (20 samples)
%convert output testing set into ones (for setosa) and zeros (for versicoor)
output=strcmp('setosa',output_testing_set); % Now, output has logical values (0 and 1). This has to be converted into double.
Y_testing = sim(net,input_testing_set);  % compute the output of the trained network

bad = (round(Y_testing)~=double(output)); % compare the output (rounded to the closest 0 or 1) of the classifier with the actual classes (testing set)
error_testing = sum(bad) / length(X1_testing); % calculate testing error
disp('Testing error is '), error_testing