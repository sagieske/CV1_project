% Function to predict classes of images using trained svm models
% Input         models: cell array of models for each class
%               centers
%               assignment
%               type_sift
%               color_space
%               channel
% Returns:      Prediction:     array of zero or ones for class prediction 
function prediction = testing(nr_test_images, models, centers, assignment, type_sift, color_space, channel_nr)
    % Create dictionary for test models
    class_dictionary_test = create_class_table('test');
    class_names = keys(class_dictionary_test);
    
    % TODO total images to be test from each class:
    total_testimages_per_class = nr_test_images;
    
    number_of_classifiers = size(class_names,2);
    
    % Initialize lists of images and their predictions
    predictions_total = cell(1,number_of_classifiers);
    for k=1:number_of_classifiers
        % Initialize cell array for classifier k
        predictions_total{k} = cell(1,total_testimages_per_class * number_of_classifiers);
    end
    
    counter = 1;
    % Test all svms for every image for every class
    testimages_total = cell(1,total_testimages_per_class* number_of_classifiers);
    % Initialize: Each predition and true value array of a classifier is stored in predictions
    predictions = cell(1,number_of_classifiers);
    d_values = cell(1, number_of_classifiers);
    true_value = cell(1,number_of_classifiers);

    for i=1:number_of_classifiers
        predictions{i} = [];
        d_values{i} = [];
        true_values{i} = [];
    end
    
    
    for k=1:number_of_classifiers
        
        class_path = char(class_names(k));
        % Get all descriptors of images
        [test_desc, test_images] = get_descriptors_class(1,total_testimages_per_class, class_dictionary_test(class_path), type_sift, color_space);
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
        end
        
        

        %disp('testing image:')
        
        % Test every image of class on all svms
        for j=1:size(test_svm,2)
            % Add testimage to list
            testimages_total{counter} = test_images{j};
            %fprintf('\nImage: %s\n', test_images{j});
            % initialize true value array
            true_value = zeros(1, size(class_names,2) );
            true_value(k) = 1;
            prediction = [];
            % Calculate predictions for each clas and add to prediction array
            for c=1:number_of_classifiers
                [pred_test, accuracy, decision_values] = svmpredict(true_value(c), test_hist(j,:), models{c}, ' -b 1 -q');                
                % Add predicted value to list
                old_array = predictions{c};
                old_d_value = d_values{c};
                predictions{c} = cat(2,old_array, pred_test);
                d_values{c} = cat(2, old_d_value, max(decision_values));
                % Add true values to list
                old_array_true = true_values{c};
                true_values{c} = cat(2,old_array_true, true_value(c));
            end
            
            %Increase counter for index of image in predictions_total
            counter = counter +1;

        end

    end

    %d_values{1}
    
    total_sorted_true_vals = cell(1, number_of_classifiers);
    total_sorted_predictions = cell(1, number_of_classifiers);
    total_sorted_images = cell(1, number_of_classifiers);
    av_mean = [];
    for c=1:number_of_classifiers
        sorted_true_vals = [];
        sorted_predictions = [];
        sorted_images = [];
        %total_mat = cat(2, predictions{c}, true_values{c}, transpose(testimages_total))
        %[sorted_pred, indices] = sort(predictions{c}, 'descend')
        %[sorted_pred, indices] = sort(predictions{c})
        pred = predictions{c};
        truevals = true_values{c};
        cl = cell(1,4);
        cl{1} = predictions{c};
        cl{2} = true_values{c};
        cl{3} = d_values{c};
        cl{4} = testimages_total;
        cl
        
        for k = 1:size(pred,2)
            if pred(k) == 1
                sorted_predictions = cat(1, pred(k), sorted_predictions);
                sorted_true_vals = cat(1, truevals(k), sorted_true_vals);
                sorted_images = cat(1, testimages_total(k), sorted_images);
            elseif predictions{c}(k) == 0
                sorted_predictions = cat(1, sorted_predictions, pred(k));
                sorted_true_vals = cat(1, sorted_true_vals, truevals(k));
                sorted_images = cat(1, sorted_images, testimages_total(k));
            end
        end
        
        %sorted_predictions
        %sorted_true_vals
        %celldisp(sorted_images)

        
        total_sorted_true_vals{c} = sorted_true_vals;
        total_sorted_predictions{c} = sorted_predictions;
        total_sorted_images{c} = sorted_images;
        count = 0;
        count_precision = 0;
        %Loop through all images
        for val=1:size(sorted_predictions)
            %If the image is in this class
            %sorted_true_vals(val)
            if sorted_true_vals(val) == 1
                %Add one to counter, and set temp_count to that value
                count = count + 1;
                temp_count = count;
            %Otherwise, set temp_count to 0
            elseif sorted_true_vals(val) == 0
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


