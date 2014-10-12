function image_descriptions = quantize_features(images, centers, assignment,  type_sift, color_space)
    amount_images = size(images)
    words_matrix = [];
    image_descriptions = {}
    % Describe each image in words
    for i = 1:amount_images
        % Get descriptor set of image
        descriptor_set = extract_features2(images(i,:), type_sift, color_space);
        words_vector = [];
        % For each descriptor calculate center k to which descriptor is
        % closes to. Append to words array describing this image
        for j = 1:size(descriptor_set,2)
            [x, k] = min(vl_alldist(single(descriptor_set(:,j)), centers));
            words_vector = cat(2, words_vector, k);
        end
        % Add array of words that describe image i to cell array list for
        % image descriptions
        image_descriptions{i} = words_vector;
    end
    