load('.\variables\collection.mat')

recObj = audiorecorder(Fs, nBits, nChannels);

pause(2)
for sample_index = 1 : sample_number
    disp("Begin speaking.")
    recordblocking(recObj, recDuration);
    disp("End of recording.")
    pause(1)

    speech_sample = getaudiodata(recObj);
    filename = strcat('.\samples\7\', num2str(sample_index), '.wav');
    audiowrite(filename, speech_sample, Fs);
end