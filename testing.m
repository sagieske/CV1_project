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
    test_class = 3;
    class_names(test_class)
    

    % Get all descriptors of images
    [test_desc, test_images] = get_descriptors_class(1,2, class_dictionary_test(char(class_names(3))), type_sift, color_space);
    % Quantize images using centers and assignment
    test_svm = quantize_features(test_images, centers, assignment, type_sift, color_space, channel_nr);

     % Create histograms
    test_hist = get_histogram(test_svm);

    size(test_svm,2)
    disp('testing image:')
    for j=1:size(test_svm,2)
         fprintf('\nImage: %s\n', test_images{j});
        % initialize true value array
        true_value = zeros(1, size(class_names,2) );
        true_value(test_class) = 1;

        prediction = [];
        % Calculate predictions for each clas and add to prediction array
        for c=1:size(class_names,2)
            [pred_test, accuracy, decision_values] = svmpredict(true_value(c), test_hist(j,:), models{c}, ' -b 1');
            prediction = cat(2,prediction, pred_test);
        end

        for i=1:size(prediction,2)
            fprintf('- Class: %s  = %i (true value: %i)\n', char(class_names(i)), prediction(i), true_value(i));
        end
    end
end


