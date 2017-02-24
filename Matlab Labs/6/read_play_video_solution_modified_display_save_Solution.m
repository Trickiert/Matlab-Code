clear all; % clear all variables from the workspace

video = mmread('Video1.mpg'); % call the function mmread to load the video.
% The variable video is a structure with different fields. Type 'video'on Matlab command and see what metadata is associated
% to this structure. 
number_of_frames=video.nrFramesTotal; % nrFramesTotal is the number of frames associated to the variable video.
height=video.height; % height is the number of rows of each frame in the video.
width=video.width; % height is the number of columns of each frame in the video.
frame_rate=video.rate;
%
% Red component video
%
video_Red=video;
for i=1:number_of_frames,
    image=video_Red.frames(i).cdata;  % get the i th frame (colour image) of the video
    image(:,:,2)=0;   % remove the Green component image in the sequence 
    image(:,:,3)=0;   % remove the Blue component image in the sequence 
    video_Red.frames(i).cdata=image;
end
mmwrite('video_Red.avi',video_Red); % save the processed video

sequence_of_frames=zeros(144,176,3,10);  %initialise a sequence of 10 frames with zeros. 
for i=1:10,
    image=video_Red.frames(i).cdata;  % get the i th frame (colour image) of the video
    sequence_of_frames(:,:,1,i)=image(:,:,1);   % put the Red component image in the sequence 
    sequence_of_frames(:,:,2,i)=image(:,:,2);   % put the Green component image in the sequence 
    sequence_of_frames(:,:,3,i)=image(:,:,3);   % put the Blue component image in the sequence 
end
mmwrite('video_Red.avi',video_Red); % save the processed video

% convert the values of the sequence into unsigned integers to apply implay
sequence_of_frames=uint8(sequence_of_frames); 
% apply implay to play the sequence at the right frame rate. 
implay(sequence_of_frames,frame_rate);

%
% Green component video
%
video_Green=video;
for i=1:number_of_frames,
    image=video_Green.frames(i).cdata;  % get the i th frame (colour image) of the video
    image(:,:,1)=0;   % remove the Red component image in the sequence 
    image(:,:,3)=0;   % remove the Blue component image in the sequence 
    video_Green.frames(i).cdata=image;
end
mmwrite('video_Green.avi',video_Green);   
%
% Blue component video
%
video_Blue=video;
for i=1:number_of_frames,
    image=video_Blue.frames(i).cdata;  % get the i th frame (colour image) of the video
    image(:,:,1)=0;   % remove the Red component image in the sequence 
    image(:,:,2)=0;   % remove the Green component image in the sequence 
    video_Blue.frames(i).cdata=image;
end
mmwrite('video_Blue.avi',video_Blue);   
%
% Red and Green component video
%
video_Red_Green=video;
for i=1:number_of_frames,
    image=video_Red_Green.frames(i).cdata;  % get the i th frame (colour image) of the video
    image(:,:,3)=0;   % remove the Blue component image in the sequence 
    video_Red_Green.frames(i).cdata=image;
end
mmwrite('video_Red_Green.avi',video_Red_Green);   
%
% Red and Blue component video
%
video_Red_Blue=video;
for i=1:number_of_frames,
    image=video_Red_Blue.frames(i).cdata;  % get the i th frame (colour image) of the video
    image(:,:,2)=0;   % remove the Green component image in the sequence 
    video_Red_Blue.frames(i).cdata=image;
end
mmwrite('video_Red_Blue.avi',video_Red_Blue);   
%
% Green and Blue component video
%
video_Green_Blue=video;
for i=1:number_of_frames,
    image=video_Green_Blue.frames(i).cdata;  % get the i th frame (colour image) of the video
    image(:,:,1)=0;   % remove the Red component image in the sequence 
    video_Green_Blue.frames(i).cdata=image;
end
mmwrite('video_Green_Blue.avi',video_Green_Blue);   