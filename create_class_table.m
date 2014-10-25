% Function creates dictionary map for all classes and their folders
% Input     usage:  create dictionary either for train or test data
function class_dictionary = create_class_table(usage)
    
    class_dictionary = containers.Map;
    if strcmp(usage, 'training')
        class_dictionary('airplanes_train') = char('CV1 Project data/data/airplanes_train/');
        class_dictionary('cars_train') = char('CV1 Project data/data/cars_train/');
        class_dictionary('faces_train') = char('CV1 Project data/data/faces_train/');
        class_dictionary('motorbikes_train') = char('CV1 Project data/data/motorbikes_train/');
    elseif strcmp(usage, 'test')
        class_dictionary('airplanes_test') = char('CV1 Project data/data/airplanes_test/');
        class_dictionary('cars_test') = char('CV1 Project data/data/cars_test/');
        class_dictionary('faces_test') = char('CV1 Project data/data/faces_test/');
        class_dictionary('motorbikes_test') = char('CV1 Project data/data/motorbikes_test/');
    end