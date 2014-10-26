% Function to predict classes of images using trained svm models
% Input         models: cell array of models for each class
%               centers
%               assignment
%               type_sift
%               color_space
%               channel
% Returns:      Prediction:     array of zero or ones for class prediction 
function prediction = testing(models, centers, assignment, type_sift, color_space, channel_nr)
    % Create dictionary for test models
    class_dictionary_test = create_class_table('test');
    class_names = keys(class_dictionary_test);
    
    % TODO total images to be test from each class:
    total_testimages_per_class = 5;
    
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
    true_value = cell(1,number_of_classifiers);

    for i=1:number_of_classifiers
        predictions{i} = [];
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
                predictions{c} = cat(2,old_array, pred_test);
                % Add true values to list
                old_array_true = true_values{c};
                true_values{c} = cat(2,old_array_true, true_value(c));
            end
            
            %Increase counter for index of image in predictions_total
            counter = counter +1;

        end

    end

    % TODO: SORT

    for c=1:number_of_classifiers
        size(testimages_total)
        size(predictions{c})
        sorted_true_vals = []
        sorted_predictions = []
        sorted_images = []
        %total_mat = cat(2, predictions{c}, true_values{c}, transpose(testimages_total))
        %[sorted_pred, indices] = sort(predictions{c}, 'descend')
        %[sorted_pred, indices] = sort(predictions{c})
        pred = predictions{c}
        truevals = true_values{c}
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
    end
        %[sorted_true, true_indices] = sort(true_values{c}, indices)
        %test_images
        %[sorted_im, im_indices] = sort(test_images, indices)
        % TODO: sort true_values{c} and test_images using indices!
        % sorted_true = TODO
        % sorted_im = TODO
        
        % EVALUATE
        
   
   
    
end


