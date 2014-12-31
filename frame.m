function frame(amount_per_class, svm_train_number, nr_test_images, amount_clusters, type_sift, color_space, dsift_sizes, dsift_step)
    % Check if the required parameters for dense sift
    % are set. If not, fill them in with the default values
    % (www.vlfeat.org/matlab/vl_phow.html)
    if(~exist('dsift_sizes', 'var'))
        dsift_sizes = [4 6 8 10];
    end
    if(~exist('dsift_step', 'var'))
       dsift_step = 2;
    end
    
    % Calculate # images for each class dependend on # training images
    train_number = amount_per_class*4;
    
    % Retrieve class mapping for training
    class_dictionary = create_class_table('training');
    disp('Extracting descriptors...') 
    [total_data_matrix, selected_images, datamatrix_per_class, selected_images_per_class] =  descriptors_all_classes(amount_per_class, class_dictionary, type_sift, color_space, dsift_sizes, dsift_step);
    
    % Data matrix for class 1, channel 1: size(datamatrix_class{1}{1})    
    data_matrix = total_data_matrix;
    
    % Build vocabulary with N visual words
    N = 400;

    %words_matrix = {};
    center_list = {};
    assignment_list = {};
    % Create seperate word matrices for channels
    %data_matrix = [];
    images_matrix = [];

    %data_matrix = total_data_matrix;
    images_matrix = selected_images;
    
    disp('Building visual vocabulary..')
    [centers, assignment] = build_vocab(single(data_matrix), amount_clusters);
    
    disp('Start SVM training..')
    disp('-Retrieving descriptors for training data..')
    [~, air_svm] = get_descriptors_class(amount_per_class,svm_train_number, class_dictionary('airplanes_train'), type_sift, color_space, dsift_sizes, dsift_step);
    [~, car_svm] = get_descriptors_class(amount_per_class,svm_train_number,class_dictionary('cars_train'), type_sift, color_space, dsift_sizes, dsift_step);
    [~, fac_svm] = get_descriptors_class(amount_per_class,svm_train_number, class_dictionary('faces_train'), type_sift, color_space, dsift_sizes, dsift_step);
    [~, mot_svm] = get_descriptors_class(amount_per_class, svm_train_number, class_dictionary('motorbikes_train'), type_sift, color_space, dsift_sizes, dsift_step);

    % Create seperate word matrices for channels
    disp('-Retrieving histograms for training data..')
    words_airplanes_svm = quantize_features(air_svm, centers, assignment, type_sift, color_space, 1, dsift_sizes, dsift_step);
    words_cars_svm = quantize_features(car_svm, centers, assignment, type_sift, color_space, 1, dsift_sizes, dsift_step);
    words_faces_svm = quantize_features(fac_svm, centers, assignment, type_sift, color_space, 1, dsift_sizes, dsift_step);
    words_motorbikes_svm = quantize_features(mot_svm, centers, assignment, type_sift, color_space, 1, dsift_sizes, dsift_step);

    N_airplanes = get_histogram(words_airplanes_svm);
    N_cars = get_histogram(words_cars_svm);
    N_faces = get_histogram(words_faces_svm);
    N_motorbikes = get_histogram(words_motorbikes_svm);

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
    predictions = testing(nr_test_images, models, centers, assignment, type_sift, color_space, channel_nr, dsift_sizes, dsift_step);
    
end
    

    

        
    