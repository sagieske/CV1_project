function average_precision = evaluation()
    n = 200; %Total number of images
    m = 50; % Number of class
    % TODO!!! IMPORT LIST
    list = [1 0 1 0 0 1 0 1]
    total_sum = 0;
    correct_counter =0;
    for i=1:n
        % if correct
        if list(i) == 1
            correct_counter = correct_counter +1; 
            total = correct_counter/i;
        else
            total = 0
        end
        total_sum = total_sum + total;
    end
    average_precision = 1/m * total_sum;
    
end
