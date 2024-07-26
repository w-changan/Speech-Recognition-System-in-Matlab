load('.\variables\collection.mat')
load('.\variables\processing.mat')
load('.\variables\dataset.mat')

recObj = audiorecorder(Fs, nBits, nChannels);
pause(2)
disp("Begin speaking.")
recordblocking(recObj, recDuration);
disp("End of recording.")
pause(1)

test_speech = getaudiodata(recObj);
[sample_ste, sample_zcr] = get_acoustic_characteristics(test_speech);

weight = 1/5;
cur_distance = Inf;
estimated_number = Inf;
for number = 0 : 9
    for sample_index = 1 : sample_number
        temp_distance = 0;
        for segment_index = 1 : segment_number
            ste_distance = abs(ste(number + 1, sample_index, segment_index) - ...
                               sample_ste(segment_index));
            zcr_distance = abs(zcr(number + 1, sample_index, segment_index) - ...
                               sample_zcr(segment_index));
            temp_distance = temp_distance + weight * ste_distance + zcr_distance;
        end
        if temp_distance < cur_distance
            cur_distance = temp_distance;
            estimated_number = number;
        end
    end
end

disp(strcat('Estimated number: ', num2str(estimated_number)))
