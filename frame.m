function frame(train_number)
    amount_per_class = round(train_number/4)
    airplanes_files = dir('airplanes_train/*.jpg'); 
    cars_files = dir('cars_train/*.jpg'); 
    faces_files = dir('faces_train/*.jpg'); 
    motorbikes_files = dir('motorbikes_train/*.jpg'); 
    data_matrix = []
    for i = 1:amount_per_class
        desc1 = extract_features(strcat('airplanes_train/', airplanes_files(i).name), 'key');
        desc2 = extract_features(strcat('cars_train/', cars_files(i).name), 'key');
        desc3 = extract_features(strcat('faces_train/', faces_files(i).name), 'key');
        desc4 = extract_features(strcat('motorbikes_train/', motorbikes_files(i).name), 'key');
        data_matrix = cat(2, data_matrix, desc1, desc2, desc3, desc4);
    end
    build_vocab(im2single(data_matrix), 400);
    size(data_matrix)
    
        
    