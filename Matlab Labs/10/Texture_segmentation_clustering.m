clear all;
I=imread('image1.jpg');
% K is the number of clusters
K=3;
[m,n]=size(I);
% construct X which is the matrix of feature vectors
%each feature vector is extracted from a block blk1 in the filtered image
%horizontally and a block blk2 in the filtered image vertically
% The size of each block is set to 4x4
blk_size=4;

mask = fspecial('sobel');  % use Sobel's filter (see lecture 9)
I1 = imfilter(I,mask,'replicate');   % horizontal operator
I2 = imfilter(I,mask','replicate');  % vertical operator

X=[]; % initialisation with empty set

for i=1:blk_size:m-blk_size+1,
    for j=1:blk_size:n-blk_size+1,
        
        blk1=I1(i:i+blk_size-1,j:j+blk_size-1);
        blk2=I2(i:i+blk_size-1,j:j+blk_size-1);
        % extract the feature vector 
        % the feature vetor consists of the mean and standard deviation of
        % each block (blk1 and blk2)
            vector=[mean(mean(abs(blk1))),std2(blk1),mean(mean(abs(blk2))),std2(blk2)]; 
     
        X=[X;vector];
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