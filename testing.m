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
    total_testimages_per_class = 50;
    
    number_of_classifiers = size(class_names,2);
    
    % Initialize lists of images and their predictions
    predictions_total = cell(1,number_of_classifiers);
    for k=1:number_of_classifiers
        % Initialize cell array for classifier k
        predictions_total{k} = cell(1,total_testimages_per_class * number_of_classifiers);
    end
    
    counter = 1;
    % Test all svms for every image for every class
    for k=1:number_of_classifiers
        
        class_path = char(class_names(k));
        % Get all descriptors of images
        [test_desc, test_images] = get_descriptors_class(1,total_testimages_per_class, class_dictionary_test(class_path), type_sift, color_space);
        % Quantize images using centers and assignment
        test_svm = quantize_features(test_images, centers, assignment, type_sift, color_space, channel_nr);

         % Create histograms
        test_hist = get_histogram(test_svm);

        %disp('testing image:')
        
        % Test every image of class on all svms
        for j=1:size(test_svm,2)
            %fprintf('\nImage: %s\n', test_images{j});
            % initialize true value array
            true_value = zeros(1, size(class_names,2) );
            true_value(k) = 1;
            prediction = [];
            % Calculate predictions for each clas and add to prediction array
            for c=1:number_of_classifiers
                [pred_test, accuracy, decision_values] = svmpredict(true_value(c), test_hist(j,:), models{c}, ' -b 1 -q');
                prediction = cat(2,prediction, pred_test);
                % Add to every classifier list (classifier = #c) a cell array containing 
                % the image name, its prediction for this classifier and the true
                % value
                %fprintf('classifier:%i location:%i\n', c, counter);
                predictions_total{c}{counter} = {test_images{j}, pred_test, true_value(c)};
            end
            
            %Increase counter for index of image in predictions_total
            counter = counter +1;

        end
    end
    
    % print classifier FACES
    classifier_test =4;
    for p=1:size(predictions_total{classifier_test},2)
        image_info = predictions_total{classifier_test}{p};
        imagename = image_info{1};
        fprintf('image: %s, predict: %i, true: %i\n', char(imagename),  image_info{2}, image_info{3})
    end
    
end


