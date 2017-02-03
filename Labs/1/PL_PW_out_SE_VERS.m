clear all; % clear all variables from the workspace
load fisheriris;
X1=[meas(1:40,3);meas(51:90,3)]; % construct X1 which represents petal length for training (80 samples)
X2=[meas(1:40,4);meas(51:90,4)]; % construct X2 which represents petal width for training (80 samples)
output_training_set=[species(1:40);species(51:90)]; % construct output data representing two classes (setosa and versicolor) for training (80 samples)
gscatter(X1, X2, output_training_set,'rg','os');
xlabel('Petal length');
ylabel('Petal width');


% remember the input training set is composed of X1 and X2
% Implementation of the training algorithm (gradient descendent) - See Lecture 1
% We assume C1=setosa and C2=versicolor
% initialise the parameters with random values
theta0=3.8; theta1=-2.4; theta2=4.5; 
% set the learning rate to 0.001 and the target error to 0.01
alpha=0.001; e_t=0.01; 
% set the initial error to e=12 (initially it should be greater than e_t to enter the loop);
e=12;
%  while loop. Set index i to 1 (first sample of the data)
number_of_iterations=0;
while (e>e_t && number_of_iterations <4000) % to make sure the programme leaves the loop at a certain stage
    % need to calculate the cost function e. Initialise it with zero.
    e=0;    
    for i=1:length(X1), 
        % find output Y for the current sample with the current system
        % parameters.
        % we then need to find those positive and negative values of the output to compare with the
        % desired output. Remember that C1 in the desired output (training_set)
        % refers to positive values (setosa). C2 refers to negative values
        % (versicolor)
        Y(i)=theta0+theta1*X1(i)+theta2*X2(i);
        % calculate delta_x (see lecture) for the current sample and then
        % update the parameters and calculate the cost function e.
        if strcmp(output_training_set(i),'setosa') && Y(i)<0,
            delta_x=-1;
            theta0=theta0-alpha*delta_x;
            theta1=theta1-alpha*delta_x*X1(i);
            theta2=theta2-alpha*delta_x*X2(i);
            e=e+delta_x*Y(i);
        elseif strcmp(output_training_set(i),'versicolor') && Y(i)>0
            delta_x=1;
            theta0=theta0-alpha*delta_x;
            theta1=theta1-alpha*delta_x*X1(i);
            theta2=theta2-alpha*delta_x*X2(i);
            e=e+delta_x*Y(i);
        end       
    end
    number_of_iterations=number_of_iterations+1;
end
% once the training is performed. The parameters of the classifier can be
% used to predict the class for the input testing set. Let's first calculate
% the classification error on the training set. 
Y=theta0+theta1*X1+theta2*X2;
error_training=0; % initialisation
for i=1:length(X1), % loop through all training samples
    if strcmp(output_training_set(i),'setosa') && Y(i)<0, % Actual class is C1 (setosa) but the output of classifier says C2
        error_training= error_training+1/length(X1); % add one divided by the number of training samples (to normalise the error between 0 and 1)
    elseif strcmp(output_training_set(i),'versicolor') && Y(i)>0, % Actual class is C2 (versicolor) but the output of classifier says C1
        error_training= error_training+1/length(X1); % add the same amount as before.
    end
end
disp('Training error is '), error_training;

% Now, we can measure the performance of the classifier on the
% test set. 
X1_testing=[meas(41:50,3);meas(91:100,3)]; % construct X1 which represents petal length for the testing (20 samples)
X2_testing=[meas(41:50,4);meas(91:100,4)]; % construct X2 which represents petal width for the testing (20 samples)
output_testing_set=[species(41:50);species(91:100)]; % construct output data representing two classes (setosa and versicolor) for testing (20 samples)
Y_testing=theta0+theta1*X1_testing+theta2*X2_testing;
error_testing=0; % initialisation
for i=1:length(X1_testing), % loop through all test samples
    if strcmp(output_testing_set(i),'setosa') && Y_testing(i)<0, % Actual class is C1 (setosa) but the output of classifier says C2
        error_testing= error_testing+1/length(X1_testing); % add one divided by the number of testing samples (to normalise the error between 0 and 1)
    elseif strcmp(output_testing_set(i),'versicolor') && Y_testing(i)>0, % Actual class is C2 (versicolor) but the output of classifier says C1
        error_testing= error_testing+1/length(X1_testing); % add the same amount as before.
    end
end
disp('Testing error is '), error_testing;

