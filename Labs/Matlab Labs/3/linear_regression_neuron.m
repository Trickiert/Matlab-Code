clear all;
load fish_training; % table has 36 rows (samples) and three columns (two inputs --> temprature and length) and one output (age)
X1=table(:,1); % construct X1 which represents temprature for training 36 samples)
X2=table(:,2); % construct X2 which represents fish length for training (36 samples)
input_training_set=[X1';X2']; % The input training set is composed of 36 columns (samples) and two rows (temprature and length)
output_training_set=table(:,3)'; % construct output data representing age for training (36 samples)


% remember the input training set is composed of X1 and X2
% call the built-in function for the training algorithm (Non-linear neural netwrok) - See
% Lecture 3
rng('default'); % set the random number generator to its default state
rng(13); % this is an integer value to initialise the random number generator

net = newff(input_training_set,output_training_set); % create a single linear neuron for linear regresion.
net.layers{1}.transferFcn='purelin';  % transfer function for the neuron is linear.
net.trainParam.epochs = 40;  % set to 40 the number of times the training samples will be used to train the network
net = train(net,input_training_set,output_training_set); % train the linear neuron with the training samples.

% once the training is performed. The linear neuron can be
% used to estimate the age for the input testing set. Let's first calculate
% the training error
Y_training = sim(net,input_training_set);  % compute the output of the trained neuron
error_training =0.5* sum((Y_training-output_training_set).^2) / length(X1); % calculate the training error
disp('Training error is '), error_training

load fish_testing; % load the test file

X1_testing=test_table(:,1); % construct X1_testing which represents temprature for testing (8 samples)
X2_testing=test_table(:,2); % construct X2_testing which represents fish length for testing (8 samples)
input_testing_set=[X1_testing';X2_testing']; % The input testing set is composed of 8 columns (samples) and two rows (temprature and length)
output_testing_set=test_table(:,3)'; % construct actual output data representing age for testing (8 samples)

Y_testing = sim(net,input_testing_set);  % compute the output of the trained network

Y_testing=floor(Y_testing); % truncate the output values to get integers (age should be given in days)