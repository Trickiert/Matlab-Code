clear all;
clc;
Image=imread('image1.tif');
[m,n]=size(Image); % size of the image

block_size=32;
hash=[]; % initialization of the hash to be extracted from each
% DCT-transformed block.
for i=1:block_size:m,
    for j=1:block_size:n,
        blk=dct2(Image(i:i+block_size-1,j:j+block_size-1)); % get the block
        hash=[hash,blk(1,2)>=0,blk(2,1)>=0];
    end
end
save original_image1_hash hash
 disp('Hash Generated');
        