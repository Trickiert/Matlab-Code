clc;
I=imread('image1_luminance.png');
%display a square region of size 5x5
I(121:125,121:125)
% calculate its DFT
Transformed=dct2(I);
energy=getEnergy(Transformed);
disp('energy of the DCT image is'), energy
imshow(20*abs(Transformed)/max(max(Transformed))), title('Transformed');% display the DCT image
%display a square region of size 5x5 of the DCT image
Transformed(121:125,121:125)
% get the energy of the squared region at the top left corner 
Squared_region=Transformed(1:100,1:100);
energy_of_squared_region=getEnergy(Squared_region);
disp('energy of the squared region at the centre is'), energy_of_squared_region

%Define a new DCT image by retaining only the 100x100 square of the DCT
%image at the top left corner
New_DCT_image=zeros(size(Transformed)); % define a matrix of zeros
New_DCT_image(1:100,1:100)=Transformed(1:100,1:100);
% apply inverse DCt transform
Reconstructed_picture=idct2(New_DCT_image);
figure,imshow(uint8(Reconstructed_picture)),title('Reconstructed');