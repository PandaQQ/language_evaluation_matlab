clear;
% subs = dir(['./*.mp4']);
% File Path
vidObj = VideoReader("./pp_01/test.mp4");
audioPath = "./pp_01/test.mp3";
frameRate = round(vidObj.FrameRate);
% Time Configuration
time_rd(1) = 60*5+46;%pre-task point
time_rd(2) = 60*6+21;%black marker point
time_rd(3) = 60*11+23;%post-task point

vidFrame = read(vidObj,time_rd(2)*frameRate);
figure();imshow(vidFrame);

[x_black_rd,y_black_rd] = ginput;x_black_rd = round(x_black_rd);y_black_rd = round(y_black_rd);
[x_white_rd,y_white_rd] = ginput;x_white_rd = round(x_white_rd);y_white_rd = round(y_white_rd);


segment = [time_rd(1)*frameRate,time_rd(3)*frameRate];
segment_len = segment(2) - segment(1);
pixel_data = [];
for j = 1:segment_len
    vidFrame = double(read(vidObj,segment(1)+j));
    for k = 1:length(y_black_rd) pixel_data(k,j) = vidFrame(y_black_rd(k),x_black_rd(k),1);end
    for k = 1:length(y_white_rd) pixel_data(k+length(y_black_rd),j) = vidFrame(y_white_rd(k),x_white_rd(k),1);end
    if rem(j,1000) == 0 disp([num2str(100*j/segment_len),'%']);end
end
corrs = [];
for j = 1:size(pixel_data,2)-1
    corrs(j) = corr([255,255,255,255,255,255,255,255,0,0,0,0,255,255,255,255]',...
        [pixel_data(1,j),pixel_data(2,j),pixel_data(3,j),pixel_data(4,j),...
        pixel_data(5,j),pixel_data(6,j),pixel_data(7,j),pixel_data(8,j),...
        pixel_data(1,j+1),pixel_data(2,j+1),pixel_data(3,j+1),pixel_data(4,j+1),...
        pixel_data(5,j+1),pixel_data(6,j+1),pixel_data(7,j+1),pixel_data(8,j+1)]');
end
figure;plot(corrs,'.');

times = find(corrs>0.98)/frameRate + time_rd(1);

[y,Fs] = audioread(audioPath);

%----------------------------------------------

% recall (show 3 seconds)
j = 1;
t_dur = 8; %second

h = figure('Units','normalized','position',[0,.2,1,.7]);
p = axes(h,'position',[.1,.6,.8,.3]);
temp = y(times(j)*Fs+1:times(j)*Fs+Fs*t_dur,:);
plot(p,linspace(0,t_dur,length(temp)),temp);
button = uicontrol(h, 'Style', 'pushbutton', 'Units','Normalized','Position',...
       [0.4 .4 0.2 0.05],'String', 'Play', 'Callback', 'sound(temp,Fs)');
   title(['Digit Span Trial: ',num2str(j)]);
title(['Sensorimotor Trial: ',num2str(j)]);
