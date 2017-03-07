clc;
I=imread('image1_luminance.jpg');
%display a square region of size 5x5
I(121:125,121:125)
% calculate its DWT
[A1,H1,V1,D1] = dwt2(double(I),'db2','mode','per');  % four sub-bands in the first decomposition
[A2,H2,V2,D2] = dwt2(double(A1),'db2','mode','per'); % second decomposition
Transformed=[[A2,H2;V2,D2],H1;V1,D1];
energy=getEnergy(Transformed);
disp('energy of the DWT image is'), energy
% This will be applied for illustration purposes only
Display_transformed=abs(Transformed);
[m,n]=size(A2);
Display_transformed(1:m,1:n)=20*Display_transformed(1:m,1:n)/max(max(Display_transformed));
imshow(Display_transformed/20), title('Transformed');% display the DWT image
%display a square region of size 5x5 of the DWT image
Transformed(321:325,421:425)
% get the energy of the approximation subband 
region=A1;
energy_of_region=getEnergy(region);
disp('energy of the approximation subband is'), energy_of_region


% apply inverse DWT transform
Reconstructed_A1=idwt2(A2,zeros(size(H2)),zeros(size(V2)),zeros(size(D2)),'db2','mode','per') ;
Reconstructed_picture=idwt2(Reconstructed_A1,zeros(size(H1)),zeros(size(V1)),zeros(size(D1)),'db2','mode','per') ;
figure,imshow(uint8(Reconstructed_picture)),title('Reconstructed');