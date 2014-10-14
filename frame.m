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

    selected_images = cell(1,train_number);
    % Get desriptors for image from each training class
    disp('Extracting features')
    for i = 1:amount_per_class
        % Append correct folder
        airplanes_name = strcat('data/airplanes_train/', airplanes_files(i).name);
        cars_name = strcat('data/cars_train/', cars_files(i).name);
        faces_name = strcat('data/faces_train/', faces_files(i).name);
        motorbikes_name = strcat('data/motorbikes_train/', motorbikes_files(i).name);
        
        % Concatenate names of images used for descriptors
        selected_images{i*4-3}  = airplanes_name;
        selected_images{i*4-2}  =  cars_name;
        selected_images{i*4-1}  = faces_name;
        selected_images{i*4}  = motorbikes_name;

        % Get descriptors
        desc1 = extract_features2(airplanes_name,  type_sift, color_space);
        desc2 = extract_features2(cars_name,  type_sift, color_space);
        desc3 = extract_features2(faces_name,  type_sift, color_space);
        desc4 = extract_features2(motorbikes_name,  type_sift, color_space);
        
        % There is always at least channel 1
        data_matrix_ch1 = cat(2, data_matrix_ch1, desc1{1}, desc2{1}, desc3{1}, desc4{1});
        %???? Seperate data_matrices for seperate channels?????
        if (~strcmp(color_space,'gray'))
            data_matrix_ch2 = cat(2, data_matrix_ch2, desc1{2}, desc2{2}, desc3{2}, desc4{2});
            data_matrix_ch3 = cat(2, data_matrix_ch3, desc1{3}, desc2{3}, desc3{3}, desc4{3});
        end
        
    end
    
    if (strcmp(color_space,'gray'))
            data_matrix = {data_matrix_ch1};
    else
        data_matrix = { data_matrix_ch1, data_matrix_ch2, data_matrix_ch3};
    end
    
    % Build vocabulary with N visual words
    N = 400;
    data_matrix_channels = size(data_matrix,2);
    words_matrix = {};
    center_list = {};
    assignment_list = {};
    % Create seperate word matrices for channels
    disp('Building vocab')
    for i = 1:data_matrix_channels
        [centers, assignment] = build_vocab(im2single(data_matrix{i}), N);
        center_list{i} = centers;
        assignment_list{i} = assignment;
        % Quantize features 
        words_matrix{i} = quantize_features(selected_images, centers, assignment, type_sift, color_space, i);
    end
    
    % Words_matrix has elements for # of channels. Each element is a cell
    % array which contains # images elements. These elements contain
    % words_vectors that describe the image in visual words
    
    % EXAMPLE: image description of image 2 in channel 1
    % image_description = words_matrix{1}{2}

    % Use channel 1 to test get_histogram for trainingnumber of images
    %get_histogram(words_matrix{1}, selected_images);
    data_matrix_ch1b = [];
    data_matrix_ch2b = [];
    data_matrix_ch3b = [];
    selected_images = cell(1,train_number);
    disp('Getting SVM training data')
    for j = amount_per_class:amount_per_class+5
        airplanes_name = strcat('data/airplanes_train/', airplanes_files(j).name);
        cars_name = strcat('data/cars_train/', cars_files(j).name);
        faces_name = strcat('data/faces_train/', faces_files(j).name);
        motorbikes_name = strcat('data/motorbikes_train/', motorbikes_files(j).name);
        
        % Concatenate names of images used for descriptors
        selected_images{j*4-3}  = airplanes_name;
        selected_images{j*4-2}  =  cars_name;
        selected_images{j*4-1}  = faces_name;
        selected_images{j*4}  = motorbikes_name;

        % Get descriptors
        desc1 = extract_features2(airplanes_name,  type_sift, color_space);
        desc2 = extract_features2(cars_name,  type_sift, color_space);
        desc3 = extract_features2(faces_name,  type_sift, color_space);
        desc4 = extract_features2(motorbikes_name,  type_sift, color_space);
    
        data_matrix_ch1b = cat(2, data_matrix_ch1b, desc1{1}, desc2{1}, desc3{1}, desc4{1});
        %???? Seperate data_matrices for seperate channels?????
        if (~strcmp(color_space,'gray'))
            data_matrix_ch2b = cat(2, data_matrix_ch2b, desc1{2}, desc2{2}, desc3{2}, desc4{2});
            data_matrix_ch3b = cat(2, data_matrix_ch3b, desc1{3}, desc2{3}, desc3{3}, desc4{3});
        end
        
    end
    if (strcmp(color_space,'gray'))
            data_matrix = {data_matrix_ch1b};
    else
        data_matrix = { data_matrix_ch1b, data_matrix_ch2b, data_matrix_ch3b};
    end
    N = 400;
    data_matrix_channels = size(data_matrix,2);
    words_matrix = {};

    % Create seperate word matrices for channels
    disp('Retrieving histograms')
    for i = 1:data_matrix_channels
        %[centers, assignment] = build_vocab(im2single(data_matrix{i}), N);
        % Quantize features 
        words_matrix{i} = quantize_features(selected_images, center_list{i}, assignment_list{i}, type_sift, color_space, i);
    end
    %If you run this you will get a billion zillion plots
    N = get_histogram(words_matrix{1});
    

    

        
    