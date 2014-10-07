function words_matrix = quantize_features(images, centers, assignment)
    amount_images = size(images)
    words_matrix = [];
    for i = 1:amount_images
        descriptor_set = extract_features(images(i,:), 'key');
        words_vector = [];
        for j = 1:size(descriptor_set,2)
            [x, k] = min(vl_alldist(single(descriptor_set(:,j)), centers));
            words_vector = cat(2, words_vector, k);
        end
        words_matrix = cat(1, words_matrix, words_vector);
    end
    