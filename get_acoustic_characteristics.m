function [sample_ste, sample_zcr] = get_acoustic_characteristics(sample)
%Get acoustic characteristics of the speech sample
%Namely calculate short time energy and zero crossing rate

load('.\variables\processing.mat', 'frame_length', 'frame_step', 'frame_number', ...
                                   'window_type', 'segment_number', ...
                                   'ste_high_threshold', 'ste_low_threshold', 'zcr_threshold')

sample_ste = zeros(segment_number, 1);
sample_zcr = zeros(segment_number, 1);

% figure(1)
% subplot(3, 1, 1)
% plot(sample)
sample = sample / max(abs(sample));
% subplot(3, 1, 2)
% plot(sample)
sample = sample - mean(sample);
% subplot(3, 1, 3)
% plot(sample)

for frame_index = 1 : frame_number
    for point_index = 1 : frame_length
        point = (frame_index - 1) * frame_step + point_index;
        switch(window_type)
            case 'Rectangular'
                Rectangular_window = 1;
                sample(point) = sample(point) * Rectangular_window;
            case 'Hamming'
                Hamming_window = 0.54 - 0.46 * cos(2 * pi * (point_index - 1) / (frame_length - 1));
                sample(point) = sample(point) * Hamming_window;
            case 'Hann'
                Hann_window = 0.5 - 0.5 * cos(2 * pi * (point_index - 1) / (frame_length - 1));
                sample(point) = sample(point) * Hann_window;
            otherwise
                disp('Wrong window type.')
        end
    end
end
% figure(2)
% plot(sample)

temp_ste = zeros(frame_number, 1);
temp_zcr = zeros(frame_number, 1);
for frame_index = 2 : frame_number - 1
    for point_index = 1 : frame_length
        point = (frame_index - 1) * frame_step + point_index;
        point_energy = sample(point) * sample(point);
        point_zero_crossing = abs(sign(sample(point)) - sign(sample(point - 1))) / 2;
        temp_ste(frame_index) = temp_ste(frame_index) + point_energy;
        temp_zcr(frame_index) = temp_zcr(frame_index) + point_zero_crossing;
    end
end
% figure(3)
% subplot(2,1,1)
% plot(temp_ste)
% subplot(2,1,2)
% plot(temp_zcr)

detected_flag = false;
start_frame = 0;
end_frame = 0;
for high_threshold_frame = 2 : frame_number - 1
    if(~detected_flag)
        if(temp_ste(high_threshold_frame) < ste_high_threshold)
            continue
        else
            detected_flag = 1;
            for low_threshold_frame = high_threshold_frame : -1 : 2
                if(temp_ste(low_threshold_frame) < ste_low_threshold)
                    if(temp_zcr(low_threshold_frame) < zcr_threshold)
                        start_frame = low_threshold_frame;
                    else
                        start_frame = low_threshold_frame + 1;
                    end
                    break
                end
            end
        end
    else
        if(temp_ste(high_threshold_frame) > ste_high_threshold)
            continue
        else
            for low_threshold_frame = high_threshold_frame : frame_number - 1
                if(temp_ste(low_threshold_frame) < ste_low_threshold)
                    if(temp_zcr(low_threshold_frame) < zcr_threshold)
                        end_frame = low_threshold_frame;
                    else
                        end_frame = low_threshold_frame - 1;
                    end
                    break
                end
            end
            break
        end
    end
end
% figure(4)
% subplot(2, 1, 1)
% plot(temp_ste(start_frame : end_frame))
% subplot(2, 1, 2)
% plot(temp_zcr(start_frame : end_frame))

voiced_frame_length = end_frame - start_frame + 1;
segment_length = fix(voiced_frame_length / segment_number);
for segment_index = 1 : segment_number
    segment_start = start_frame + (segment_index - 1) * segment_length;
    segment_end = segment_start + segment_length - 1;
    sample_ste(segment_index) = mean(temp_ste(segment_start : segment_end));
    sample_zcr(segment_index) = mean(temp_zcr(segment_start : segment_end));
end
% figure(5)
% subplot(2, 1, 1)
% ste_plot = squeeze(ste(1, 1, :));
% plot(ste_plot)
% subplot(2, 1, 2)
% zcr_plot = squeeze(zcr(1, 1, :));
% plot(zcr_plot)