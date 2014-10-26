function average_precision = evaluation()
    %n = 200; %Total number of images
    % TODO!!! IMPORT LIST

    list = [1 1 1 0 0 1 0 1]

    n = size(list,2)
    m = 50; % Number of class
    total_sum = 0;
    correct_counter =0;
    
    % loop over all elements x
    for i=1:n
        % if correct
        if list(i) == 1
            correct_counter = correct_counter +1; 
            total = correct_counter/i;
        % else return 0
        else
            total = 0;
        end
        % sumation over term
        total_sum = total_sum + total
    end
    
    % total average precision for this class
    average_precision = 1/m * total_sum;
    
end
