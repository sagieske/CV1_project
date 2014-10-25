% Returns   total_data_matrix:      cell array of length # channels, each
%                                   channel has datamatrices of all classes
%                                   combined in matrix
%           selected_images:        cell array of all images that were used (
%                                   in same order as total_data_matrix
%           datamatrix_per_class:   cell array of length # classes, each
%                                   element is a cell array of descriptors (length # channels) per
%                                   class. Each element i in the descriptor
%                                   is a data_matrix of all images from
%                                   that class in channel i
%           selected_images_p_class cell array of images used for
%                                   data_matrix_per_class

function [total_data_matrix, selected_images, datamatrix_per_class, selected_images_per_class] =  descriptors_all_classes(amount_per_class, class_dictionary, type_sift, color_space)

    if (~strcmp(color_space,'gray'))
        channels = 3;
    else
    	channels = 1;
    end
    
    % Initialize everything
    class_dictionary.Count
    number_of_classes = class_dictionary.Count;
    datamatrix_per_class = cell(1,number_of_classes);
    selected_images_per_class = cell(1,number_of_classes);
    total_data_matrix = cell(1,channels);

    % Get number of channels
    selected_images = {};
    
    % Loop over all classes to get data_matrix (of possible multiple
    % channels per class)
    classes = values(class_dictionary)
    for c=1:number_of_classes
        % Convert from cell to string
        class = char(classes(c));
        fprintf('- Retrieving %i images from class %s for training.\n', amount_per_class, class);
        [matrix, images_names] = get_descriptors_class(1, amount_per_class, class, type_sift, color_space);
        datamatrix_per_class{c} = matrix;
        selected_images_per_class{c} = images_names;
        % append image file names to cell array
        selected_images= cat(2 , selected_images , selected_images_per_class{c});
        % Append to total data matrix for training
        for i=1:channels
            total_data_matrix{i} = cat(2, total_data_matrix{i}, matrix{i});
        end        
    end
    disp('done')