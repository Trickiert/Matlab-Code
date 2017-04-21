clear;
clc;
load original_image1_hash; % load the hash of the first image
hash1=hash;
load original_image4_hash; % load the hash of the second image
hash2=hash;
% get the hash length
hash_length=length(hash1);
% calculate the normalised manhattan distance
distance=mandist(hash1,hash2')/hash_length;
if distance<0.20,
    disp('The two images are similar. Distance is ');distance
else
    disp('The two images are dissimilar. Distance is ');distance
end