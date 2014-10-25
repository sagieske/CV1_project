function frame(train_number,  type_sift, color_space)
    % Calculate # images for each class dependend on # training images
    amount_per_class = round(train_number/4)
    % Get file information of jpg images from directories
    %airplanes_files = dir('CV1_Project_data/data/airplanes_train/*.jpg'); 
    %cars_files = dir('CV1_Project_data/data/cars_train/*.jpg'); 
    %faces_files = dir('CV1_Project_data/data/faces_train/*.jpg'); 
    %motorbikes_files = dir('CV1_Project_data/data/motorbikes_train/*.jpg'); 
    data_matrix_ch1 = [];
    data_matrix_ch2 = [];
    data_matrix_ch3 = [];

    % Retrieve class mapping for training
    class_dictionary = create_class_table('training');
    [total_data_matrix, selected_images, datamatrix_per_class, selected_images_per_class] =  descriptors_all_classes(amount_per_class, class_dictionary, type_sift, color_space);
    
    % Data matrix for class 1, channel 1: size(datamatrix_class{1}{1})
    
    data_matrix = total_data_matrix;
    
    % Build vocabulary with N visual words
    N = 400;

    words_matrix = {};
    center_list = {};
    assignment_list = {};
    % Create seperate word matrices for channels
    data_matrix = [];
    images_matrix = [];
    
    %data_matrix = cat(2, data_matrix_airplane{1}, data_matrix_car{1}, data_matrix_face{1}, data_matrix_motorbike{1});
    data_matrix = total_data_matrix{1};
    %images_matrix = cat(1, air_im, car_im, fac_im, mot_im);
    images_matrix = selected_images;
    
    disp('Building vocab')
    [centers, assignment] = build_vocab(im2single(data_matrix), N);
    center_list = centers;
    assignment_list = assignment;
        % Quantize features 
    words_matrix = quantize_features(images_matrix, centers, assignment, type_sift, color_space, 1);
 
    
    % Words_matrix has elements for # of channels. Each element is a cell
    % array which contains # images elements. These elements contain
    % words_vectors that describe the image in visual words
    
    % EXAMPLE: image description of image 2 in channel 1
    % image_description = words_matrix{1}{2}

    % Use channel 1 to test get_histogram for trainingnumber of images
    %get_histogram(words_matrix{1}, selected_images);
    airplanes_svm = [];
    cars_svm = [];
    faces_svm = [];
    motorbikes_svm = [];
    selected_images = cell(1,train_number);
    [airplanes_svm, air_svm] = get_descriptors_class(1,5, class_dictionary('airplanes_train'), 'key', 'gray');
    [cars_svm, car_svm] = get_descriptors_class(1,5,class_dictionary('cars_train'), 'key', 'gray');
    [faces_svm, fac_svm] = get_descriptors_class(1,5, class_dictionary('faces_train'), 'key', 'gray');
    [motorbikes_svm, mot_svm] = get_descriptors_class(1, 5, class_dictionary('motorbikes_train'), 'key', 'gray');
    
    disp('Getting SVM training data')

    N = 400;
    data_matrix_channels = size(data_matrix,2);
    words_matrix = {};

    % Create seperate word matrices for channels
    disp('Retrieving histograms')
    words_airplanes_svm = quantize_features(air_svm, centers, assignment, type_sift, color_space, 1);
    words_cars_svm = quantize_features(car_svm, centers, assignment, type_sift, color_space, 1);
    words_faces_svm = quantize_features(fac_svm, centers, assignment, type_sift, color_space, 1);
    words_motorbikes_svm = quantize_features(mot_svm, centers, assignment, type_sift, color_space, 1);
    disp('eeeyo')

    %histograms per class
    N_airplanes = get_histogram(words_airplanes_svm);
    N_cars = get_histogram(words_cars_svm);
    N_faces = get_histogram(words_faces_svm);
    N_motorbikes = get_histogram(words_motorbikes_svm);
    
    N_all = cat(1, N_airplanes, N_cars, N_faces, N_motorbikes);
    correct = ones(5,1);
    false = zeros(5,1);
    
    airplanes_label = cat(1, correct, false, false, false);
    cars_label = cat(1, false, correct, false, false);
    faces_label = cat(1, false, false, correct, false);
    motorbikes_label = cat(1, false, false, false, correct)
    N_all
    
    model_airplanes = svmtrain(airplanes_label, N_all);
    model_cars = svmtrain(cars_label, N_all);
    model_faces = svmtrain(faces_label, N_all);
    model_motorbikes = svmtrain(motorbikes_label, N_all);
    
    testim = imload('CV Project data/data/airplanes_test/img001.jpg');
    testdesc = extract_features2('CV Project data/airplanes_test/img001.jpg', 'key', 'gray');
    
    
    % TODO: one or two steps missing, not really sure what should happen
    % but I'll figure it out
    %test_svm = quantize_features(**MAGIC**);
    
    %test_hist = get_histogram(test_svm);
    
    % [predicted_label] = svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')
    pred_test_air = svmpredict([1], test_hist, model_airplanes);
    pred_test_car = svmpredict([1], test_hist, model_cars);
    pred_test_face = svmpredict([1], test_hist, model_faces);
    pred_test_mot = svmpredict([1], test_hist, model_motorbikes);
    
    % If pred_test_something == [1], then the image **should** be part of
    % that class. 
    
end
    

    

        
    