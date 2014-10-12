function frame(train_number,  type_sift, color_space)
    % Calculate # images for each class dependend on # training images
    amount_per_class = round(train_number/4)
    % Get file information of jpg images from directories
    airplanes_files = dir('data/airplanes_train/*.jpg'); 
    cars_files = dir('data/cars_train/*.jpg'); 
    faces_files = dir('data/faces_train/*.jpg'); 
    motorbikes_files = dir('data/motorbikes_train/*.jpg'); 
    data_matrix = [];
    selected_images = [];
    % Get desriptors for image from each training class
    for i = 1:amount_per_class
        desc1 = extract_features2(strcat('data/airplanes_train/', airplanes_files(i).name),  type_sift, color_space);
        desc2 = extract_features2(strcat('data/cars_train/', cars_files(i).name),  type_sift, color_space);
        desc3 = extract_features2(strcat('data/faces_train/', faces_files(i).name),  type_sift, color_space);
        desc4 = extract_features2(strcat('data/motorbikes_train/', motorbikes_files(i).name),  type_sift, color_space);

        % Concatenate descriptors
        if (strcmp(color_space,'gray'))
            data_matrix = cat(2, data_matrix, desc1, desc2, desc3, desc4);
            % Concatenate names of images used for descriptors
            selected_images = cat(1, selected_images, airplanes_files(i).name, cars_files(i).name, faces_files(i).name, motorbikes_files(i).name);
        else
            break
        end
        
    end
    % Build vocabulary with N visual words
    N = 400;
    size(data_matrix)
    [centers, assignment] = build_vocab(im2single(data_matrix), N);
    % Quantize features 
    words_matrix = quantize_features(selected_images, centers, assignment);
    size(words_matrix)
    
        
    