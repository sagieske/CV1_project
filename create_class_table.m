% Function creates dictionary map for all classes and their folders
% Input     usage:              create dictionary either for train or test data
% Output    class_dictionary:   dictionary for mapping between class name
%                               and path in
function class_dictionary = create_class_table(usage)
    
    class_dictionary = containers.Map;
    if strcmp(usage, 'training')
        class_dictionary('airplanes_train') = char('CV1 Project/data/airplanes_train/');
        class_dictionary('cars_train') = char('CV1 Project/data/cars_train/');
        class_dictionary('faces_train') = char('CV1 Project/data/faces_train/');
        class_dictionary('motorbikes_train') = char('CV1 Project/data/motorbikes_train/');
    elseif strcmp(usage, 'test')
        class_dictionary('airplanes_test') = char('CV1 Project/data/airplanes_test/');
        class_dictionary('cars_test') = char('CV1 Project/data/cars_test/');
        class_dictionary('faces_test') = char('CV1 Project/data/faces_test/');
        class_dictionary('motorbikes_test') = char('CV1 Project/data/motorbikes_test/');
    end