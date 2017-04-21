clear;
folder_C1=dir('training_images\C1\');
folder_C2=dir('training_images\C2\');
folder_C3=dir('training_images\C3\');
folder_C4=dir('training_images\C4\');
folder_C5=dir('training_images\C5\');
folder_C6=dir('training_images\C6\');
folder_C7=dir('training_images\C7\');
folder_C8=dir('training_images\C8\');
folder_C9=dir('training_images\C9\');
folder_C10=dir('training_images\C10\');
Number_C1=length(folder_C1)-2; % number of images in C1
Number_C2=length(folder_C2)-2; % number of images in C2
Number_C3=length(folder_C3)-2; % number of images in C3
Number_C4=length(folder_C4)-2; % number of images in C4
Number_C5=length(folder_C5)-2; % number of images in C5
Number_C6=length(folder_C6)-2; % number of images in C6
Number_C7=length(folder_C7)-2; % number of images in C7
Number_C8=length(folder_C8)-2; % number of images in C8
Number_C9=length(folder_C9)-2; % number of images in C9
Number_C10=length(folder_C10)-2; % number of images in C10

input_training_set=[];
output_training_set=[];
% Construct the training set 
% each training feature vector is extracted 
% by using the DCT. Please see function get_featureVector
% dimension of the classifier is 64 (64 features)
for i=1:Number_C1,
    Image=imread(['training_images\C1\' folder_C1(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];   
    output_training_set=[output_training_set;1 0 0 0 0 0 0 0 0 0];
end
k=i;
for i=1:Number_C2,
    Image=imread(['training_images\C2\' folder_C2(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 1 0 0 0 0 0 0 0 0];
   
end
k=k+i;
for i=1:Number_C3,
    Image=imread(['training_images\C3\' folder_C3(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 1 0 0 0 0 0 0 0];
   
end
k=k+i;
for i=1:Number_C4,
    Image=imread(['training_images\C4\' folder_C4(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 1 0 0 0 0 0 0];
   
end
k=k+i;
for i=1:Number_C5,
    Image=imread(['training_images\C5\' folder_C5(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 0 1 0 0 0 0 0];
   
end
k=k+i;
for i=1:Number_C6,
    Image=imread(['training_images\C6\' folder_C6(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 0 0 1 0 0 0 0];
   
end
k=k+i;
for i=1:Number_C7,
    Image=imread(['training_images\C7\' folder_C7(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 0 0 0 1 0 0 0];
   
end
k=k+i;
for i=1:Number_C8,
    Image=imread(['training_images\C8\' folder_C8(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 0 0 0 0 1 0 0];
   
end
k=k+i;
for i=1:Number_C9,
    Image=imread(['training_images\C9\' folder_C9(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 0 0 0 0 0 1 0];
   
end
k=k+i;
for i=1:Number_C10,
    Image=imread(['training_images\C10\' folder_C10(i+2).name]);
    input_training_set=[input_training_set;get_featureVector(Image)'];
    output_training_set=[output_training_set;0 0 0 0 0 0 0 0 0 1];
   
end

rand('state',17);
input_training_set=input_training_set'; % get the right arrangement for the input set. 
output_training_set=output_training_set'; % get the right arrangement for the output set


net = newpr(input_training_set,output_training_set,[25 20]); % create a network for non-linear classification, 25 neurons in first hidden layer 
% and 20 in the second.
net.layers{1}.transferFcn='tansig';  % transfer function for the neurons in first hidden layer is tangent sigmoid.
net.layers{2}.transferFcn='logsig';  % transfer function for the neurons in second hidden layer is tangent sigmoid.
net.layers{3}.transferFcn='purelin';  % transfer function for the neurons in the output layer is linear.
net.trainParam.epochs = 40;  % set to 40 the number of times the training samples will be used to train the network
net = train(net,input_training_set,output_training_set); % train the network with the training samples.



    
