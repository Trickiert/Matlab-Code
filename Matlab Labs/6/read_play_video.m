clear all; % clear all variables from the workspace

video = mmread('Video1.mpeg'); % call the function mmread to load the video.
% The variable video is a structure with different fields. Type 'video'on Matlab command and see what metadata is associated
% to this structure. 
number_of_frames=video.nrFramesTotal; % nrFramesTotal is the number of frames associated to the variable video.
height=video.height; % height is the number of rows of each frame in the video.
width=video.width; % height is the number of columns of each frame in the video.
frame_rate=video.rate;
% To play the video on Matlab, the built-in function implay can be used.
% However, a 4-D matrix of size (width x height x 3 x number_of_frames) has
% to be constructed. This is a colour video and 3 represents the R, G, and B
% planes for each frame. Check help on built-in function 'implay'
sequence_of_frames=zeros(144,176,3,number_of_frames);  %initialise a sequence of frames with zeros. 
for i=1:number_of_frames,
    image=video.frames(i).cdata;  % get the i th frame (colour image) of the video
    sequence_of_frames(:,:,1,i)=image(:,:,1);   % put the Red component image in the sequence 
    sequence_of_frames(:,:,2,i)=image(:,:,2);   % put the Green component image in the sequence 
    sequence_of_frames(:,:,3,i)=image(:,:,3);   % put the Blue component image in the sequence 
end

% convert the values of the sequence into unsigned integers to apply implay
sequence_of_frames=uint8(sequence_of_frames); 
% apply implay to play the sequence at the right frame rate. 
implay(sequence_of_frames,frame_rate);
% The following function can be used to save the video in a file (video.avi)
%mmwrite('video.avi',video);   