function frame(train_number,  type_sift, color_space)
    % Calculate # images for each class dependend on # training images
    amount_per_class = round(train_number/4)
    % Get file information of jpg images from directories
    airplanes_files = dir('data/airplanes_train/*.jpg'); 
    cars_files = dir('data/cars_train/*.jpg'); 
    faces_files = dir('data/faces_train/*.jpg'); 
    motorbikes_files = dir('data/motorbikes_train/*.jpg'); 
    data_matrix_ch1 = [];
    data_matrix_ch2 = [];
    data_matrix_ch3 = [];

    selected_images = [];
    % Get desriptors for image from each training class
    for i = 1:amount_per_class
        desc1 = extract_features2(strcat('data/airplanes_train/', airplanes_files(i).name),  type_sift, color_space);
        desc2 = extract_features2(strcat('data/cars_train/', cars_files(i).name),  type_sift, color_space);
        desc3 = extract_features2(strcat('data/faces_train/', faces_files(i).name),  type_sift, color_space);
        desc4 = extract_features2(strcat('data/motorbikes_train/', motorbikes_files(i).name),  type_sift, color_space);

        % There is always at least channel 1
        data_matrix_ch1 = cat(2, data_matrix_ch1, desc1{1}, desc2{1}, desc3{1}, desc4{1});
        % Concatenate descriptors
        if (~strcmp(color_space,'gray'))
            %???? Seperate data_matrices for seperate channels?????
            data_matrix_ch2 = cat(2, data_matrix_ch2, desc1{2}, desc2{2}, desc3{2}, desc4{2});
            data_matrix_ch3 = cat(2, data_matrix_ch3, desc1{3}, desc2{3}, desc3{3}, desc4{3});
        end
         % Concatenate names of images used for descriptors
        selected_images = cat(1, selected_images, airplanes_files(i).name, cars_files(i).name, faces_files(i).name, motorbikes_files(i).name);
        
    end
    
    if (strcmp(color_space,'gray'))
            size(data_matrix_ch1)
            data_matrix = {data_matrix_ch1};
    else
        data_matrix = { data_matrix_ch1, data_matrix_ch2, data_matrix_ch3};
    end
    
    % Build vocabulary with N visual words
    N = 400;
    data_matrix_channels = size(data_matrix,2);
    words_matrix = {};
    % Create seperate word matrices for channels
    for i = 1:data_matrix_channels
        [centers, assignment] = build_vocab(im2single(data_matrix{i}), N);
        % Quantize features 
        words_matrix{i} = quantize_features(selected_images, centers, assignment, type_sift, color_space, i);
    end
    
    % Words_matrix has elements for # of channels. Each element is a cell
    % array which contains # images elements. These elements contain
    % words_vectors that describe the image in visual words
    
    % EXAMPLE: image description of image 2 in channel 1
    % image_description = words_matrix{1}{2}

    % Use channel 1 to test get histogram
    get_histogram(words_matrix{1});

    

        
    