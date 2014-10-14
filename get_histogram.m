function normalized_matrix = get_histogram(words_matrix)
    % For every image, create histogram
    a = 1:400;
    size(words_matrix)
    normalized_matrix = []
    for i = 1:size(words_matrix,2)
        %figure('name',selected_images{i}),
        %hist(words_matrix{i})
        N = hist(words_matrix{i}, a);
        Nsum = sum(N);
        Nnorm = N/Nsum;
        normalized_matrix = cat(1, normalized_matrix, Nnorm);
    end
    size(normalized_matrix)
end
    