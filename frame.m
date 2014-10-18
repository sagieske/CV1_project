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

    % Get desriptors for image from each training class
    disp('Extracting features')
    classes = {'data/airplanes_train/', 'data/cars_train/', 'data/faces_train/', 'data/motorbikes_train/'} ;
    [total_data_matrix, selected_images, datamatrix_per_class, selected_images_per_class] =  descriptors_all_classes(amount_per_class, classes, type_sift, color_space);
    
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
    [airplanes_svm, air_svm] = get_descriptors_class(5, 'data/airplanes_train/', 'key', 'gray');
    [cars_svm, car_svm] = get_descriptors_class(5, 'data/cars_train/', 'key', 'gray');
    [faces_svm, fac_svm] = get_descriptors_class(5, 'data/faces_train/', 'key', 'gray');
    [motorbikes_svm, mot_svm] = get_descriptors_class(5, 'data/motorbikes_train/', 'key', 'gray');
    
    disp('Getting SVM training data')
%     for j = amount_per_class:amount_per_class+5
%         airplanes_name = strcat('data/airplanes_train/', airplanes_files(j).name);
%         cars_name = strcat('data/cars_train/', cars_files(j).name);
%         faces_name = strcat('data/faces_train/', faces_files(j).name);
%         motorbikes_name = strcat('data/motorbikes_train/', motorbikes_files(j).name);
%         
%         % Concatenate names of images used for descriptors
%         selected_images{j*4-3}  = airplanes_name;
%         selected_images{j*4-2}  =  cars_name;
%         selected_images{j*4-1}  = faces_name;
%         selected_images{j*4}  = motorbikes_name;
% 
%         % Get descriptors
%         desc1 = extract_features2(airplanes_name,  type_sift, color_space);
%         desc2 = extract_features2(cars_name,  type_sift, color_space);
%         desc3 = extract_features2(faces_name,  type_sift, color_space);
%         desc4 = extract_features2(motorbikes_name,  type_sift, color_space);
%     
%         data_matrix_ch1b = cat(2, data_matrix_ch1b, desc1{1}, desc2{1}, desc3{1}, desc4{1});
%         %???? Seperate data_matrices for seperate channels?????
%         if (~strcmp(color_space,'gray'))
%             data_matrix_ch2b = cat(2, data_matrix_ch2b, desc1{2}, desc2{2}, desc3{2}, desc4{2});
%             data_matrix_ch3b = cat(2, data_matrix_ch3b, desc1{3}, desc2{3}, desc3{3}, desc4{3});
%         end
%         
%     end
%     if (strcmp(color_space,'gray'))
%             data_matrix = {data_matrix_ch1b};
%     else
%         data_matrix = { data_matrix_ch1b, data_matrix_ch2b, data_matrix_ch3b};
%     end
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
    correct = ones(5,1);
    false = zeros(5,1);
    
    airplanes_label = cat(1, correct, false, false, false);
    cars_label = cat(1, false, correct, false, false);
    faces_label = cat(1, false, false, correct, false);
    motorbikes_label = cat(1, false, false, false, correct);
    
    model_airplanes = svmtrain(airplanes_label, N_all);
    model_cars = svmtrain(cars_label, N_all);
    model_faces = svmtrain(faces_label, N_all);
    model_motorbikes = svmtrain(motorbikes_label, N_all);
    
    testim = imload('data/airplanes_test/img001.jpg');
    testdesc = extract_features2('data/airplanes_test/img001.jpg', 'key', 'gray');
    
    
    % TODO: one or two steps missing, not really sure what should happen
    % but I'll figure it out
    test_svm = quantize_features(**MAGIC**);
    
    test_hist = get_histogram(test_svm);
    
    % [predicted_label] = svmpredict(testing_label_vector, testing_instance_matrix, model, 'libsvm_options')
    pred_test_air = svmpredict([1], test_hist, model_airplanes);
    pred_test_car = svmpredict([1], test_hist, model_cars);
    pred_test_face = svmpredict([1], test_hist, model_faces);
    pred_test_mot = svmpredict([1], test_hist, model_motorbikes);
    
    % If pred_test_something == [1], then the image **should** be part of
    % that class. 
    
end
    

    

        
    