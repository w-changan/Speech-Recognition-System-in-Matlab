load('.\variables\collection.mat')

frame_length = 1000;
frame_offset = 200;
frame_step = frame_length - frame_offset;
frame_number = fix((Fs * recDuration - frame_offset) / frame_step);

window_type = 'Hamming';

segment_number = 3;

ste_high_threshold = 15;
ste_low_threshold = 5;
zcr_threshold = 160;

save('.\variables\processing.mat', 'frame_length', 'frame_offset', 'frame_step', 'frame_number', ...
                         'window_type', 'segment_number', ...
                         'ste_high_threshold', 'ste_low_threshold', 'zcr_threshold')
