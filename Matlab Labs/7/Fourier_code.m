clc;
I=imread('image1_luminance.png');
%display a square region of size 5x5
I(121:125,121:125)
% calculate its DFT
Transformed=fft2(I);
Transformed=fftshift(Transformed); % Use this function to centre the DC coefficient
energy=getEnergy(abs(Transformed));
disp('energy of the spectrum is'), energy
imshow(20*abs(Transformed)/max(max(Transformed))), title('Transformed');% display the spectrum
%display a square region of size 5x5 of the spectrum
abs(Transformed(121:125,121:125))
% get the energy of the squared region at the centre 
[m,n]=size(Transformed); % get the size of the matrix to find the centre
Squared_region=abs(Transformed(floor(m/2)-50:floor(m/2)+49,floor(n/2)-50:floor(n/2)+49));
energy_of_squared_region=getEnergy(Squared_region);
disp('energy of the squared region at the centre is'), energy_of_squared_region