load('.\variables\collection.mat')
load('.\variables\processing.mat')

ste_to_zcr_weight = [
    1/500 1/400 1/300 1/200 1/100 ...
    1/90 1/80 1/70 1/60 1/50 1/40 1/30 1/20 1/10 ...
    1/9 1/8 1/7 1/6 1/5 1/4 1/3 1/2 ...
    1 ...
    2 3 4 5 6 7 8 9 ...
    10 20 30 40 50 60 70 80 90 ...
    100 200 300 400 500
];

total_accuracy = zeros(45, 1);
for i = 1 : 45
    weight = ste_to_zcr_weight(i);
    number_accurate_times = zeros(10, 1);
    test_times = 10000;
    for test_index = 1 : test_times
        test_sample_index = unidrnd(sample_number, 10, 1);
        for test_number = 0 : 9
            cur_distance = Inf;
            estimated_number = Inf;
            for number = 0 : 9
                for sample_index = 1 : sample_number
                    temp_distance = 0;
                    if(sample_index == test_sample_index(number + 1))
                        continue
                    else
                        for segment_index = 1 : segment_number
                            ste_distance = abs(ste(number + 1, sample_index, segment_index) - ...
                                               ste(test_number + 1, test_sample_index(number + 1), segment_index));
                            zcr_distance = abs(zcr(number + 1, sample_index, segment_index) - ...
                                               zcr(test_number + 1, test_sample_index(number + 1), segment_index));
                            temp_distance = temp_distance + weight * ste_distance + zcr_distance;
                        end
                        if temp_distance < cur_distance
                            cur_distance = temp_distance;
                            estimated_number = number;
                        end
                    end
                end
            end
            if(estimated_number == test_number)
                number_accurate_times(test_number + 1) = number_accurate_times(test_number + 1) + 1;
            end
        end
    end
    number_accuracy = number_accurate_times / test_times;
    total_accuracy(i) = mean(number_accuracy);
end

plot(total_accuracy)
title('Overall Accuracy')
xlim(1, 45)
set(gca,'XTicklabel', {
    '1/500' '1/400' '1/300' '1/200' '1/100' ...
    '1/90' '1/80' '1/70' '1/60' '1/50' '1/40' '1/30' '1/20' '1/10' ...
    '1/9' '1/8' '1/7' '1/6' '1/5' '1/4' '1/3' '1/2' ...
    '1' ...
    '2' '3' '4' '5' '6' '7' '8' '9' ...
    '10' '20' '30' '40' '50' '60' '70' '80' '90' ...
    '100' '200' '300' '400' '500'
})
