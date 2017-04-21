clear all;
I=imread('image4.jpg');
% Thresholding is the classification of each pixel into two types of information (background/object)
[m,n]=size(I);
T=graythresh(I);
segmented_image=I>=T*255;
imshow(uint8(I)),title('Original image'),figure,imshow(segmented_image),title('Segmented image')