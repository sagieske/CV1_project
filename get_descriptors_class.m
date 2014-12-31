% input:    startN:         image number to start procedure from
%           N:              number of images from class
%           classfolder:    path to folder with images of class
%           type_sift:      
%           color space:

function [data_matrix_class, selected_images] = get_descriptors_class(startN, N, classfolder,type_sift, color_space, dsift_sizes, dsift_step)
    % Get all jpg image information in class folder
    class_files = dir(strcat(classfolder, '*.jpg')); 
    class_files_total = size(class_files,1);
    if startN + N-1 > class_files_total
        N = class_files_total - startN;
        fprintf('There are not enough class files. Will use %i\n', N);
    end
    
    selected_images = cell(1,N);
    
    data_matrix_class = [];
    % Matlab starts count at 1
    if startN < 1
        startN = 1;
    end
    counter = 1;
    for i = startN:startN+N-1
        % Append correct folder
        imagename = strcat(classfolder, class_files(i).name);
        selected_images{counter} = imagename;
        % Get descriptors
        descriptors = extract_features3(imagename,  type_sift, color_space, dsift_sizes, dsift_step);
        data_matrix_class = [data_matrix_class single(descriptors)];
        counter = counter + 1;
    end    
end
