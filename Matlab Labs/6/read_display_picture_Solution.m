clear all; % clear all variables from the workspace
Image=imread('\image3.jpg');
figure, imshow(Image); title('Displayed Picture');
% Red component
Red_Component_Image=Image;
Red_Component_Image(:,:,2)=0;
Red_Component_Image(:,:,3)=0;
figure, imshow(Red_Component_Image); title('Displayed Red Band');
imwrite(Red_Component_Image,'Image3_Red.jpg');
% Green component
Green_Component_Image=Image;
Green_Component_Image(:,:,1)=0;
Green_Component_Image(:,:,3)=0;
figure, imshow(Green_Component_Image); title('Displayed Green Band');
imwrite(Green_Component_Image,'Image3_Green.jpg');
% Blue component
Blue_Component_Image=Image;
Blue_Component_Image(:,:,1)=0;
Blue_Component_Image(:,:,2)=0;
figure, imshow(Blue_Component_Image); title('Displayed Blue Band');
imwrite(Blue_Component_Image,'Image3_Blue.jpg');
% Red and Green component 
Red_Green_Component_Image=Image;
Red_Green_Component_Image(:,:,3)=0;
figure, imshow(Red_Green_Component_Image); title('Displayed Red and green Bands');
imwrite(Red_Green_Component_Image,'Image3_Red_Green.jpg');
% Red and Blue component 
Red_Blue_Component_Image=Image;
Red_Blue_Component_Image(:,:,2)=0;
figure, imshow(Red_Blue_Component_Image); title('Displayed Red and Blue Bands');
imwrite(Red_Blue_Component_Image,'Image3_Red_Blue.jpg');
% Green and Blue component 
Green_Blue_Component_Image=Image;
Green_Blue_Component_Image(:,:,1)=0;
figure, imshow(Green_Blue_Component_Image); title('Displayed Green and Blue Bands');
imwrite(Green_Blue_Component_Image,'Image3_Green_Blue.jpg');