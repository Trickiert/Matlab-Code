clear all; % clear all variables from the workspace
Image=imread('\Image1.jpg');
figure, imshow(Image); title('Original Picture');
logo_image=imread('\logo.jpg');
[nrow,ncol]=size(logo_image);  % get the size of the logo image (number of columns and rows)
Image(1:nrow,1:ncol,1)=logo_image;   % insert a logo at the top left side of the image.
Image(1:nrow,1:ncol,2)=logo_image; 
Image(1:nrow,1:ncol,3)=logo_image; 
figure, imshow(Image); title('Picture with logo');