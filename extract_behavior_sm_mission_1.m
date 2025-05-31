clear;

% subs = dir(['./*.mp4']);
% File Path
vidObj = VideoReader("./pp_01/test.mp4");
audioPath = "./pp_01/test.mp3";
frameRate = round(vidObj.FrameRate);
% Time Configuration
time_sm(1) = 60*0+10;%pre-task point
time_sm(2) = 60*0+41;%black marker point
time_sm(3) = 60*2+13;%post-task point


vidFrame = read(vidObj, time_sm(2) * frameRate);
figure();imshow(vidFrame);
[x_black_sm,y_black_sm] = ginput;x_black_sm = round(x_black_sm);y_black_sm = round(y_black_sm);
[x_white_sm,y_white_sm] = ginput;x_white_sm = round(x_white_sm);y_white_sm = round(y_white_sm);


segment = [time_sm(1)*frameRate,time_sm(3)*vidObj.FrameRate];
segment_len = segment(2) - segment(1);
pixel_data = [];
for j = 1:segment_len
    vidFrame = double(read(vidObj,segment(1)+j));
    for k = 1:length(y_black_sm) pixel_data(k,j) = vidFrame(y_black_sm(k),x_black_sm(k),1);end
    for k = 1:length(y_white_sm) pixel_data(k+length(y_black_sm),j) = vidFrame(y_white_sm(k),x_white_sm(k),1);end
    if rem(j,1000) == 0 disp([num2str(100*j/segment_len),'%']);end
end
corrs = [];
for j = 1:size(pixel_data,2)-1
    corrs(j) = corr([255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,0,255,255,255,255,255,255]',...
        [pixel_data(1,j),pixel_data(2,j),pixel_data(3,j),pixel_data(4,j),pixel_data(5,j),pixel_data(6,j),...
        pixel_data(7,j),pixel_data(8,j),pixel_data(9,j),pixel_data(10,j),pixel_data(11,j),pixel_data(12,j),...
        pixel_data(1,j+1),pixel_data(2,j+1),pixel_data(3,j+1),pixel_data(4,j+1),pixel_data(5,j+1),pixel_data(6,j+1),...
        pixel_data(7,j+1),pixel_data(8,j+1),pixel_data(9,j+1),pixel_data(10,j+1),pixel_data(11,j+1),pixel_data(12,j+1)]');
end
figure;plot(corrs,'.');

times = find(corrs>0.98)/frameRate + time_sm(1);

[y,Fs] = audioread(audioPath);

%----------------------------------------------

% sensorimotor (show 3 seconds)
j = 15;
t_dur = 3;%second


h = figure('Units','normalized','position',[0,.2,1,.7]);
p = axes(h,'position',[.1,.6,.8,.3]);
temp = y(times(j)*Fs+1:times(j)*Fs+Fs*3,:);
plot(p,linspace(0,t_dur,length(temp)),temp);
button = uicontrol(h, 'Style', 'pushbutton', 'Units','Normalized','Position',...
       [0.4 .4 0.2 0.05],'String', 'Play', 'Callback', 'sound(temp,Fs)');
   title(['Digit Span Trial: ',num2str(j)]);
title(['Sensorimotor Trial: ',num2str(j)]);
