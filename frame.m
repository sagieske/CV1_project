function frame(train_number)
    amount_per_class = round(train_number/4)
    airplanes_files = dir('data/airplanes_train/*.jpg'); 
    cars_files = dir('data/cars_train/*.jpg'); 
    faces_files = dir('data/faces_train/*.jpg'); 
    motorbikes_files = dir('data/motorbikes_train/*.jpg'); 
    data_matrix = [];
    selected_images = [];
    for i = 1:amount_per_class
        desc1 = extract_features(strcat('data/airplanes_train/', airplanes_files(i).name), 'key');
        desc2 = extract_features(strcat('data/cars_train/', cars_files(i).name), 'key');
        desc3 = extract_features(strcat('data/faces_train/', faces_files(i).name), 'key');
        desc4 = extract_features(strcat('data/motorbikes_train/', motorbikes_files(i).name), 'key');
        data_matrix = cat(2, data_matrix, desc1, desc2, desc3, desc4);
        selected_images = cat(1, selected_images, airplanes_files(i).name, cars_files(i).name, faces_files(i).name, motorbikes_files(i).name);
    end
    [centers, assignment] = build_vocab(im2single(data_matrix), 400);
    words_matrix = quantize_features(selected_images, centers, assignment);
    size(words_matrix)
    
        
    