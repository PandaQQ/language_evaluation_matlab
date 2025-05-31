# Language Evaluation Matlab - User Guide

### Video and Audio Configuration and Settings:
- MATLAB Version: R2025a
- When acquiring videos, we need to create folders to classify them by participant: for example, pp01, pp02.
- How to extract audio: https://cloudconvert.com/mp4-to-mp3
- Place each participant's test.mp3 and test.mp4 into their respective folders (pp01, pp02, etc.).

Video User Guide:

### Detail Usage Guide:

#### Step 1: 
- Config your test.mp4 and test.mp3 file at line 5-6 with this file: extract_behavior_sm_mission_1.m
- You can adjust as you want pp_02, pp03
```
vidObj = VideoReader("./pp_01/test.mp4");
audioObj = audioread('./pp_01/test.mp3');
```

#### Step 2:
- Time Configuration:
```
time_sm(1) = 60*0+10;%pre-task point, it's means before the task start time.
time_sm(2) = 60*0+41;%black marker point, it's means the frame show the black makers.
time_sm(3) = 60*2+13;%post-task point, it's means the end of your task time.
```

#### Step 3:
- Show your result:
```
% sensorimotor (show 3 seconds)
j = 1; % if you have 15 taks within SensorMotor, type 1 to 15 to check the results
t_dur = 3;%second, the window that length of your duration.
```