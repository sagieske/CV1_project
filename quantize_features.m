function words_matrix = quantize_features(images, centers, assignment)
    amount_images = size(images)
    words_matrix = [];
    % Describe each image in words
    for i = 1:amount_images
        % Get descriptor set of image
        descriptor_set = extract_features(images(i,:), 'key');
        words_vector = [];
        % For each descriptor calculate center k to which descriptor is
        % closes to. Append to words array describing this image
        for j = 1:size(descriptor_set,2)
            [x, k] = min(vl_alldist(single(descriptor_set(:,j)), centers));
            words_vector = cat(2, words_vector, k);
        end
        % Add array of words that describe image i to words matrix
        words_matrix = cat(1, words_matrix, words_vector);
    end
    