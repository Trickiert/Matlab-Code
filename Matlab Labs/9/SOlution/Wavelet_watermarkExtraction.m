clear all;
Image=imread('watermarked_image.tif');
% initialization of the watermark sequence to be extracted from each sub-band.
watermark_H3=[];
watermark_V3=[];
watermark_D3=[];
watermark_A3=[];
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
for i=1:8,%  there are 8 coefficients to embed 8 bits in A3
    %Now get the location of the coeffficient to hold one bit
    row_number=key(i,1); column_number=key(i,2);
    % get each wavelet coefficient in A3.
    coefficient_A3=A3(row_number,column_number);
    % Apply the extraction equation for each coefficient.
    Q_coefficient_A3=round(coefficient_A3/Quantization_step); % quantization
    if mod(Q_coefficient_A3,2)==0, % get the watermark bit. If the quantized coefficient is even, then watermark bit is 0
        watermark_A3=[watermark_A3,0];
    else
        watermark_A3=[watermark_A3,1]; % If the quantized coefficient is odd, then watermark bit is 1
    end
    
end

disp('extracted watermark in A3: '),watermark_A3