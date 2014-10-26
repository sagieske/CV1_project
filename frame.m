function frame(amount_per_class, svm_train_number, amount_clusters, type_sift, color_space)
    % Calculate # images for each class dependend on # training images
    train_number = amount_per_class*4;
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
    images_matrix = selected_images;
    
    disp('Building vocab')
    [centers, assignment] = build_vocab(im2single(data_matrix), amount_clusters);
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
    
    disp('SVM DEBUG')
    %svm_train_number = svm_train_number + amount_per_class
    [airplanes_svm, air_svm] = get_descriptors_class(amount_per_class,svm_train_number, class_dictionary('airplanes_train'), 'key', 'gray');
    [cars_svm, car_svm] = get_descriptors_class(amount_per_class,svm_train_number,class_dictionary('cars_train'), 'key', 'gray');
    [faces_svm, fac_svm] = get_descriptors_class(amount_per_class,svm_train_number, class_dictionary('faces_train'), 'key', 'gray');
    [motorbikes_svm, mot_svm] = get_descriptors_class(amount_per_class, svm_train_number, class_dictionary('motorbikes_train'), 'key', 'gray');

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

    %histograms per class
    N_airplanes = get_histogram(words_airplanes_svm);
    N_cars = get_histogram(words_cars_svm);
    N_faces = get_histogram(words_faces_svm);
    N_motorbikes = get_histogram(words_motorbikes_svm);

    N_all = cat(1, N_airplanes, N_cars, N_faces, N_motorbikes);
    correct = ones(svm_train_number,1);
    false = zeros(svm_train_number,1);
    %false = repmat(-1, svm_train_number, 1);
    
    airplanes_label = cat(1, correct, false, false, false);
    cars_label = cat(1, false, correct, false, false);
    faces_label = cat(1, false, false, correct, false);
    motorbikes_label = cat(1, false, false, false, correct);
    
    %PARAMS SVM:
%     -t kernel_type
%         set type of kernel function (default 2)
%         0 - linear - u'*v
%         1 - polynomial - gamma*u'*v + coef0)^degree
%         2 - radial basis function - exp(-gamma*|u-v|^2)
%         3 - sigmoid - tanh(gamma*u'*v + coef0)
%         4 - precomputed kernel (kernel values in training_set_file)
%     
%     -b probability_estimates
%         whether to train an SVC or SVR model for probability estimates, 0 or 1 (default 0)
        
    model_airplanes = svmtrain(airplanes_label, N_all, '-t 3 -b 1 -q');
    model_cars = svmtrain(cars_label, N_all, '-t 3 -b 1 -q');
    model_faces = svmtrain(faces_label, N_all, '-t 3 -b 1 -q');
    model_motorbikes = svmtrain(motorbikes_label, N_all, '-t 3 -b 1 -q');
    
    models = {model_airplanes, model_cars, model_faces, model_motorbikes};

    % TODO channels!
    channel_nr = 1;
    % TESTING
    prediction = testing(models, centers, assignment, type_sift, color_space, channel_nr);
    
end
    

    

        
    