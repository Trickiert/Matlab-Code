clear all;
clc;
Image=imread('image1.tif');
watermark=[0 1 0 0 1 1 0 1]; % this is the watermark sequence to be embedded. (Binary)

load key_file; % now Matlab knows a variable named 'key' containing the locations at which the watermark will be embedded
%********************* DWT transform
[A1,H1,V1,D1] = dwt2(double(Image),'haar','mode','per');  % four sub-bands in the first decomposition
[A2,H2,V2,D2] = dwt2(double(A1),'haar','mode','per'); % second decomposition
[A3,H3,V3,D3] = dwt2(double(A2),'haar','mode','per'); % Third decomposition
% Embed the watermark in A3
% Each coefficient is identified by its location from key. Remember that key is a
% matrix of size 8x2 containing the coordinates (row number and column number) for each of the eight coefficients 
% Loop 'for' can be used.
Quantization_step=30;
for i=1:8,%  there are 8 coefficients to embed 8 bits in each sub-band (H3,V3,D3)
    %Now get the location of the coeffficient to hold one bit
    row_number=key(i,1); column_number=key(i,2);
    % get each wavelet coefficient in A3.
    coefficient_A3=A3(row_number,column_number);
    % Apply the embedding equation for each coefficient.
    Q_coefficient_A3=round(coefficient_A3/Quantization_step); % quantization
    if watermark(i)==0, % check the watermark bit. If 0, the quantized coefficient has to be even
        if mod(Q_coefficient_A3,2)~=0, % if it is not even add 1.
            Q_coefficient_A3=Q_coefficient_A3+1;
        end
    else % if the watermark bit is 1, the quantized coefficient has to be odd.
        if mod(Q_coefficient_A3,2)==0, % if it is even add 1.
            Q_coefficient_A3=Q_coefficient_A3+1;
        end
    end
    reconstructed_coefficient_A3=Q_coefficient_A3*Quantization_step; 
    A3(row_number,column_number)=reconstructed_coefficient_A3; % place the coefficient that now hides the watermark back in A3.
end
    
% apply inverse DWT transform to reconstruct the watermarked image and then
% display and save it.
Reconstructed_A2=idwt2(A3,H3,V3,D3,'haar','mode','per');
Reconstructed_A1=idwt2(Reconstructed_A2,H2,V2,D2,'haar','mode','per') ;
Reconstructed_picture=idwt2(Reconstructed_A1,H1,V1,D1,'haar','mode','per') ;
imshow(Image),title('Original Image');
figure,imshow(uint8(round(Reconstructed_picture))), title('watermarked image')

imwrite(uint8(round(Reconstructed_picture)),'watermarked_image.tif');












