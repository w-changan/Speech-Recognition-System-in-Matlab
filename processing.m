load('.\variables\processing.mat')

ste = zeros(10, sample_number, segment_number);
zcr = zeros(10, sample_number, segment_number);

for number = 0 : 9
    for sample_index = 1 : sample_number
        filename = strcat('.\samples\', num2str(number), '\', num2str(sample_index), '.wav');
        [sample, fs] = audioread(filename);
        [sample_ste, sample_zcr] = get_acoustic_characteristics(sample);
        ste(number + 1, sample_index, :) = sample_ste;
        zcr(number + 1, sample_index, :) = sample_zcr;
    end
end

save('.\variables\dataset.mat', 'ste', 'zcr')
