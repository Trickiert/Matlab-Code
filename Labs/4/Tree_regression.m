clear all;
load fish_training; % table has 36 rows (samples) and three columns (two inputs --> temprature and length) and one output (age)
X1=table(:,1); % construct X1 which represents temprature for training 36 samples)
X2=table(:,2); % construct X2 which represents fish length for training (36 samples)
input_training_set=[X1,X2]; % The input training set is composed of 36 columns (samples) and two rows (temprature and length)
output_training_set=table(:,3); % construct output data representing age for training (36 samples)


% remember the input training set is composed of X1 and X2
t = classregtree(input_training_set, output_training_set); % build a classification tree using the training samples
view(t);  % show the trained tree

% once the training is performed. The tree can be
% used to to estimate the age for the input testing set.  Let's first calculate
% the classification error on the training set. 

Y_training = eval(t,input_training_set);  % compute the output of the regression tree


load fish_testing; % load the test file

X1_testing=test_table(:,1); % construct X1_testing which represents temprature for testing (8 samples)
X2_testing=test_table(:,2); % construct X2_testing which represents fish length for testing (8 samples)
input_testing_set=[X1_testing,X2_testing]; % The input testing set is composed of 8 columns (samples) and two rows (temprature and length)
output_testing_set=test_table(:,3); % construct actual output data representing age for testing (8 samples)

Y_testing = eval(t,input_testing_set);  % compute the output of the regression tree

Y_testing=floor(Y_testing); % truncate the output values to get integers (age should be given in days)