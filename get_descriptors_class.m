% input:    startN:         image number to start procedure from
%           N:              number of images from class
%           classfolder:    path to folder with images of class
%           type_sift:      
%           color space:

function [data_matrix_class, selected_images] = get_descriptors_class(startN, N, classfolder,type_sift, color_space)
    % Get all jpg image information in class folder
    class_files = dir(strcat(classfolder, '*.jpg')); 
    N
    selected_images = cell(1,N);
    
    % init for channels
    data_matrix_ch1 = [];
    data_matrix_ch2 = []; 
    data_matrix_ch3 = [];
    
    data_matrix_class = {};
    % Matlab starts count at 1
    if startN < 1
        startN = 1
    end
    
    for i = startN:N
        % Append correct folder
        imagename = strcat(classfolder, class_files(i).name);
        selected_images{i} = imagename;
        % Get descriptors
        descriptors = extract_features2(imagename,  type_sift, color_space);
         % There is always at least channel 1
        data_matrix_ch1 = cat(2, data_matrix_ch1, descriptors{1});
        %???? Seperate data_matrices for seperate channels?????
        if (~strcmp(color_space,'gray'))
            data_matrix_ch2 = cat(2, data_matrix_ch2, descriptors{2});
            data_matrix_ch3 = cat(2, data_matrix_ch3, descriptors{3});
        end      
    end
    
    % Put in data_matrix cell array
    if (strcmp(color_space,'gray'))
            data_matrix_class{1} = data_matrix_ch1;
    else
        data_matrix_class = { data_matrix_ch1, data_matrix_ch2, data_matrix_ch3};
    end
    
end
