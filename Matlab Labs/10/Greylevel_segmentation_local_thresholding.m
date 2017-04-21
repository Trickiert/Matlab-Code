clear all;
I=imread('image4.jpg');
% Thresholding is the classification of each pixel into two types of information (background/object)
[m,n]=size(I);
segmented_image=zeros(m,n); % initialisation with zero
blk_size=32;
for i=1:blk_size:m-blk_size+1,
    for j=1:blk_size:n-blk_size+1,
        local_T=graythresh(I(i:i+blk_size-1,j:j+blk_size-1));
        segmented_image(i:i+blk_size-1,j:j+blk_size-1)=I(i:i+blk_size-1,j:j+blk_size-1)>=local_T*255;
    end
end
imshow(uint8(I)),title('Original image'),figure,imshow(segmented_image),title('Segmented image')