clear all;
I=imread('image4.jpg');
% K is the number of clusters
K=3;
[m,n]=size(I);
% construct X which is the matrix of feature vectors
%each feature vector is extracted from a block blk in the greylevel image
% The size of each block is set to 2x2
blk_size=2;


X=[]; % initialisation with empty set

for i=1:blk_size:m-blk_size+1,
    for j=1:blk_size:n-blk_size+1,
        
        % extract the feature vector 
        % the feature vetor consists of the pixel values of the block in
        % the greylevel image
        vector=double(I(i:i+blk_size-1,j:j+blk_size-1)); 
     
        X=[X;vector(:)'];
    end
end
idx = kmeans(X,K);
J = reshape(idx,n/blk_size,m/blk_size);
J=J';  
index=1;
segmented_image=zeros(m,n);
for i=1:blk_size:m-blk_size+1,
    for j=1:blk_size:n-blk_size+1,
        segmented_image(i:i+blk_size-1,j:j+blk_size-1)=50*J(floor(i/blk_size)+1,floor(j/blk_size)+1)/255;
        index=index+1;
    end
end
imshow(uint8(I)),title('Original image'),figure,imshow(segmented_image),title('Segmented image')