% Function to predict classes of images using trained svm models
% Input         models: cell array of models for each class
%               centers
%               assignment
%               type_sift
%               color_space
%               channel
% Returns:      Prediction:     array of zero or ones for class prediction 
function predictions = testing(nr_test_images, models, centers, assignment, type_sift, color_space, channel_nr)
    % Create dictionary for test models
    class_dictionary_test = create_class_table('test');
    class_names = keys(class_dictionary_test);
        
    number_of_classifiers = size(class_names,2);
    
    % Initialize lists of images and their predictions
    predictions_total = cell(1,number_of_classifiers);
    for k=1:number_of_classifiers
        % Initialize cell array for classifier k
        predictions_total{k} = cell(1,nr_test_images * number_of_classifiers);
    end
    
    counter = 1;
    % Test all svms for every image for every class
    testimages_total = cell(1,nr_test_images* number_of_classifiers);
    % Initialize: Each predition and true value array of a classifier is stored in predictions
    predictions = cell(1,number_of_classifiers);
    d_values = cell(1, number_of_classifiers);
    true_value = cell(1,number_of_classifiers);

%     for i=1:number_of_classifiers
%         predictions{i} = [];
%         d_values{i} = [];
%         true_values{i} = [];
%     end
    
    % array to get all histograms
    total_hist = [];
    
    total_images  = [];
    % Get all histograms for images for each classifier. Append to total_hist
    for k=1:number_of_classifiers
        % Get class to retrieve descriptors
        class_path = char(class_names(k));
        % Get all descriptors of images
        [test_desc, test_images] = get_descriptors_class(1,nr_test_images, class_dictionary_test(class_path), type_sift, color_space);
        % Quantize images using centers and assignment
        
        if(~strcmp(color_space, 'gray'))
            test_svm_ch1 = quantize_features(test_images, centers, assignment, type_sift, color_space, 1);
            test_svm_ch2 = quantize_features(test_images, centers, assignment, type_sift, color_space, 2);
            test_svm_ch3 = quantize_features(test_images, centers, assignment, type_sift, color_space, 3);
            
            test_hist_ch1 = get_histogram(test_svm_ch1);
            test_hist_ch2 = get_histogram(test_svm_ch2);
            test_hist_ch3 = get_histogram(test_svm_ch3);
            
            test_hist_matrix = [test_hist_ch1 test_hist_ch2 test_hist_ch3];
            
            test_hist = mean(test_hist_matrix, 2);
            
            test_svm = test_svm_ch1;
        else
            test_svm = quantize_features(test_images, centers, assignment, type_sift, color_space, channel_nr);

             % Create histograms
            test_hist = get_histogram(test_svm);
            % Append histograms and testimages to total list
            total_hist = cat(1, total_hist, test_hist);
            total_images = cat(1,total_images , transpose(test_images));
        end
    end
    
    % Convert array to cell array
    testimages_total = cellstr(total_images);
    
    % Generate true values array
    true_values = cell(1, number_of_classifiers);
    correct = ones(nr_test_images,1);
    false = zeros(nr_test_images,1);
    
    true_values{1} = cat(1, correct, false, false, false);
    true_values{2} = cat(1, false, correct, false, false);
    true_values{3} = cat(1, false, false, correct, false);
    true_values{4} = cat(1, false, false, false, correct);
        
    % Test all for each classifier
    for classifier=1:number_of_classifiers
        [pred_test, accuracy, decision_values] = svmpredict(true_values{classifier}, total_hist, models{classifier}, ' -b 1 -q'); 
        d_values{classifier} = transpose(decision_values(:,2));
        predictions{classifier} = pred_test;
    end

    
    total_sorted_true_vals = cell(1, number_of_classifiers);
    total_sorted_predictions = cell(1, number_of_classifiers);
    total_sorted_images = cell(1, number_of_classifiers);
    av_mean = [];
        
    for c=1:number_of_classifiers
        
        all_mat = cell(1,4);
        all_mat{1} = transpose(predictions{c});
        all_mat{2} = transpose(true_values{c});
        all_mat{3} = d_values{c};
        all_mat{4} = transpose(testimages_total);
        [sort_all, indices] = sort(all_mat{3}, 'descend');
        if(c==1)
            all_mat_sort = {fliplr(all_mat{1}(indices)), fliplr(all_mat{2}(indices)), sort_all, fliplr(all_mat{4}(indices))}
        else
            all_mat_sort = {all_mat{1}(indices), all_mat{2}(indices), sort_all, all_mat{4}(indices)}
        end
        all_mat_sort{1};
        all_mat_sort{2};
        all_mat_sort{3};
        transpose(all_mat_sort{4})

        
        %sorted_predictions
        %sorted_true_vals
        %celldisp(sorted_images)

        
        
        count = 0;
        count_precision = 0;
        sort_true = all_mat_sort{2};
        %Loop through all images
        for val=1:size(sort_true,2)
            %If the image is in this class
            %sorted_true_vals(val)
            sort_true(val);
            if sort_true(val) == 1
                %Add one to counter, and set temp_count to that value
                count = count + 1;
                temp_count = count;
            %Otherwise, set temp_count to 0
            elseif sort_true(val) == 0
                temp_count = 0;
            end
            %Divide temp_count by the number of iterations
            new_p = temp_count/val;
            %And add that precision to the total precision
            count_precision = count_precision + new_p;
        end
    %Total count_precision needs to be multiplied by 1/number of images in
    % this class
    av_mean(c) = count_precision * (1/size(test_images,2));
    end
    av_mean
    av_mean_p = sum(av_mean)/4
end
