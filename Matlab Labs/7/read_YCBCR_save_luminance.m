I=imread('image4.png'); % pass through image
J=rgb2ycbcr(I);

Y=J(:,:,1);  % Get the luminance plane
Cb=J(:,:,2); % Get the first chrominance plane
Cr=J(:,:,3); % Get the second chrominance plane
% Display
imshow(Y), title('Luminance');
figure,imshow(Cb), title('First chrominance plane');
figure, imshow(Cr), title('Second chrominance plane');
imwrite(Y,'image1_luminance.png');