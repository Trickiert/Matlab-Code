clear all;
I=imread('image2.jpg');
% K is the number of clusters
K=5;
[m,n]=size(I);
% construct X which is the matrix of feature vectors
%each feature vector is extracted from a subband in a block blk of the transformed image
% except the approximation subband because it is a low frequency subband
% The size of each block is set to 8x8
blk_size=8;

X=[]; % initialisation with empty set

for i=1:blk_size:m-blk_size+1,
    for j=1:blk_size:n-blk_size+1,
        blk=double(I(i:i+blk_size-1,j:j+blk_size-1)); % get the block 
        [A1,H1,V1,D1] = dwt2(blk,'haar','mode','per');  % four sub-bands in the first decomposition of the block
        [A2,H2,V2,D2] = dwt2(A1,'haar','mode','per'); % second decomposition
        vector=[mean(mean(abs(H1))),std2(H1),mean(mean(abs(V1))),std2(V1),mean(mean(abs(D1))),std2(D1),mean(mean(abs(H2))),std2(H2),...
            mean(mean(abs(V2))),std2(V2),mean(mean(abs(D2))),std2(D2)]; % use mean and standard deviation
     
        X=[X;vector];  % each row in X is a feature vector corresponding to a block
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