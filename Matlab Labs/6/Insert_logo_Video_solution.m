clear all; % clear all variables from the workspace
logo_image=imread('\logo.jpg');
[nrow,ncol]=size(logo_image);  % get the size of the logo image (number of columns and rows)
video = mmread('Video1.mpg'); % call the function mmread to load the video.
% The variable video is a structure with different fields. Type 'video'on Matlab command and see what metadata is associated
% to this structure. 
number_of_frames=video.nrFramesTotal; % nrFramesTotal is the number of frames associated to the variable video.
height=video.height; % height is the number of rows of each frame in the video.
width=video.width; % height is the number of columns of each frame in the video.
frame_rate=video.rate;
sequence_of_frames=zeros(height,width,3,number_of_frames);  %initialise a sequence of frames with zeros. 
for i=1:number_of_frames,
    image=video.frames(i).cdata;                % get the i th frame (colour image) of the video
    image(1:nrow,1:ncol,1)=logo_image;          % insert a logo at the top left side of the frame.
    image(1:nrow,1:ncol,2)=logo_image;
    image(1:nrow,1:ncol,3)=logo_image;
    sequence_of_frames(:,:,1,i)=image(:,:,1);   % put the Red component image in the sequence 
    sequence_of_frames(:,:,2,i)=image(:,:,2);   % put the Green component image in the sequence 
    sequence_of_frames(:,:,3,i)=image(:,:,3);   % put the Blue component image in the sequence 
    video.frames(i).cdata=image;                % put the frame which contains the logo in the video.
end
% convert the values of the sequence into unsigned integers to apply implay
sequence_of_frames=uint8(sequence_of_frames); 
% apply implay to play the sequence at the right frame rate. 
implay(sequence_of_frames,frame_rate);
mmwrite('video_logo.avi',video);   