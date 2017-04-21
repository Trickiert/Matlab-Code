% testing phase - Test Images are in folder test_images 
clc
folder=dir('test_images\C1\');
Number_of_images=length(folder)-2; % number of images in C1

for i=1:Number_of_images,
    test_image=imread(['test_images\C1\' folder(i+2).name]);
    feature_vector=get_featureVector(test_image); % function get_featureVector returns a column vector. 
    Y_testing = sim(net,feature_vector);  % compute the output of the trained network

    disp('output of network for image '),disp(i),disp('is'),round(Y_testing)
end
    
