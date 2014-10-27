function frame(amount_per_class, svm_train_number, nr_test_images, amount_clusters, type_sift, color_space)
    % Calculate # images for each class dependend on # training images
    train_number = amount_per_class*4;
    
    % Retrieve class mapping for training
    class_dictionary = create_class_table('training');
    disp('Extracting descriptors...') 
    [total_data_matrix, selected_images, datamatrix_per_class, selected_images_per_class] =  descriptors_all_classes(amount_per_class, class_dictionary, type_sift, color_space);
    
    % Data matrix for class 1, channel 1: size(datamatrix_class{1}{1})    
    data_matrix = total_data_matrix;
    
    % Build vocabulary with N visual words
    N = 400;

    %words_matrix = {};
    center_list = {};
    assignment_list = {};
    % Create seperate word matrices for channels
    data_matrix = [];
    images_matrix = [];

    data_matrix = total_data_matrix{1};
    images_matrix = selected_images;
    
    disp('Building visual vocabulary..')
    [centers, assignment] = build_vocab(im2single(data_matrix), amount_clusters);
    center_list = centers;
    assignment_list = assignment;

    % Use channel 1 to test get_histogram for trainingnumber of images
    %get_histogram(words_matrix{1}, selected_images);
    airplanes_svm = [];
    cars_svm = [];
    faces_svm = [];
    motorbikes_svm = [];
    selected_images = cell(1,train_number);
    
    disp('Start SVM training..')
    disp('-Retrieving descriptors for training data..')
    [airplanes_svm, air_svm] = get_descriptors_class(amount_per_class,svm_train_number, class_dictionary('airplanes_train'), type_sift, color_space);
    [cars_svm, car_svm] = get_descriptors_class(amount_per_class,svm_train_number,class_dictionary('cars_train'), type_sift, color_space);
    [faces_svm, fac_svm] = get_descriptors_class(amount_per_class,svm_train_number, class_dictionary('faces_train'), type_sift, color_space);
    [motorbikes_svm, mot_svm] = get_descriptors_class(amount_per_class, svm_train_number, class_dictionary('motorbikes_train'), type_sift, color_space);


    N = 400;
    data_matrix_channels = size(data_matrix,2);

    % Create seperate word matrices for channels
    disp('-Retrieving histograms for training data..')
    if(~strcmp(color_space, 'gray'))
        disp('--colorspace 1 - quantize features')
        words_airplanes_svm_ch1 = quantize_features(air_svm, centers, assignment, type_sift, color_space, 1);
        words_cars_svm_ch1 = quantize_features(car_svm, centers, assignment, type_sift, color_space, 1);
        words_faces_svm_ch1 = quantize_features(fac_svm, centers, assignment, type_sift, color_space, 1);
        words_motorbikes_svm_ch1 = quantize_features(mot_svm, centers, assignment, type_sift, color_space, 1);

        disp('--colorspace 2 - quantize features')
        words_airplanes_svm_ch2 = quantize_features(air_svm, centers, assignment, type_sift, color_space, 2);
        words_cars_svm_ch2 = quantize_features(car_svm, centers, assignment, type_sift, color_space, 2);
        words_faces_svm_ch2 = quantize_features(fac_svm, centers, assignment, type_sift, color_space, 2);
        words_motorbikes_svm_ch2 = quantize_features(mot_svm, centers, assignment, type_sift, color_space, 2);

        disp('--colorspace 3 - quantize features')
        words_airplanes_svm_ch3 = quantize_features(air_svm, centers, assignment, type_sift, color_space, 3);
        words_cars_svm_ch3 = quantize_features(car_svm, centers, assignment, type_sift, color_space, 3);
        words_faces_svm_ch3 = quantize_features(fac_svm, centers, assignment, type_sift, color_space, 3);
        words_motorbikes_svm_ch3 = quantize_features(mot_svm, centers, assignment, type_sift, color_space, 3);

        %histograms per class
        disp('--colorspace 1 - get histograms')
        N_airplanes_ch1 = get_histogram(words_airplanes_svm_ch1);
        N_cars_ch1 = get_histogram(words_cars_svm_ch1);
        N_faces_ch1 = get_histogram(words_faces_svm_ch1);
        N_motorbikes_ch1 = get_histogram(words_motorbikes_svm_ch1);

        disp('--colorspace 2 - get histograms')
        N_airplanes_ch2 = get_histogram(words_airplanes_svm_ch2);
        N_cars_ch2 = get_histogram(words_cars_svm_ch2);
        N_faces_ch2 = get_histogram(words_faces_svm_ch2);
        N_motorbikes_ch2 = get_histogram(words_motorbikes_svm_ch2);

        disp('--colorspace 3 - get histograms')
        N_airplanes_ch3 = get_histogram(words_airplanes_svm_ch3);
        N_cars_ch3 = get_histogram(words_cars_svm_ch3);
        N_faces_ch3 = get_histogram(words_faces_svm_ch3);
        N_motorbikes_ch3 = get_histogram(words_motorbikes_svm_ch3);

        N_airplanes_matrix = [N_airplanes_ch1 N_airplanes_ch2 N_airplanes_ch3];
        N_cars_matrix = [N_cars_ch1 N_cars_ch2 N_cars_ch3];
        N_faces_matrix = [N_faces_ch1 N_faces_ch2 N_faces_ch3];
        N_motorbikes_matrix = [N_motorbikes_ch1 N_motorbikes_ch2 N_motorbikes_ch3];

        N_airplanes = mean(N_airplanes_matrix, 2);
        N_cars = mean(N_cars_matrix, 2);
        N_faces = mean(N_faces_matrix, 2);
        N_motorbikes = mean(N_motorbikes_matrix, 2);
    
    else
        words_airplanes_svm = quantize_features(air_svm, centers, assignment, type_sift, color_space, 1);
        words_cars_svm = quantize_features(car_svm, centers, assignment, type_sift, color_space, 1);
        words_faces_svm = quantize_features(fac_svm, centers, assignment, type_sift, color_space, 1);
        words_motorbikes_svm = quantize_features(mot_svm, centers, assignment, type_sift, color_space, 1);
        
        N_airplanes = get_histogram(words_airplanes_svm);
        N_cars = get_histogram(words_cars_svm);
        N_faces = get_histogram(words_faces_svm);
        N_motorbikes = get_histogram(words_motorbikes_svm);
    end

    % Create vector of true labels
    N_all = cat(1, N_airplanes, N_cars, N_faces, N_motorbikes);
    correct = ones(svm_train_number,1);
    false = zeros(svm_train_number,1);
    
    airplanes_label = cat(1, correct, false, false, false);
    cars_label = cat(1, false, correct, false, false);
    faces_label = cat(1, false, false, correct, false);
    motorbikes_label = cat(1, false, false, false, correct);
    
    % Create models for different classes and add them to models cellarray
    disp('-Training SVM models..')
    model_airplanes = svmtrain(airplanes_label, N_all, '-t 3 -b 1 -q');
    model_cars = svmtrain(cars_label, N_all, '-t 3 -b 1 -q');
    model_faces = svmtrain(faces_label, N_all, '-t 3 -b 1 -q');
    model_motorbikes = svmtrain(motorbikes_label, N_all, '-t 3 -b 1 -q');
    models = {model_airplanes, model_cars, model_faces, model_motorbikes};

    channel_nr = 1;
    % Use models on test images
    disp('Start classification test images using SVM models')
    predictions = testing(nr_test_images, models, centers, assignment, type_sift, color_space, channel_nr);
    
end
    

    

        
    