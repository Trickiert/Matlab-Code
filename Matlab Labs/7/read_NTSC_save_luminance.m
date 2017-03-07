clear all;
Image=imread('image4.png'); % Get image
J=rgb2ntsc(Image); % Method, takes in Image defined above.

Y=J(:,:,1);  % Get the luminance plane
I=J(:,:,2); % Get the hue plane
Q=J(:,:,3); % Get the saturation plane
% Display
imshow(Y), title('Luminance');
figure,imshow(I), title('Hue plane');
figure, imshow(Q), title('Saturation plane');
