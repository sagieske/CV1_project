function Nnorm = get_histogram(words_matrix, selected_images, centers, assignment)
    % For every image, create histogram
    a = 0:400
    for i = 1:size(words_matrix,1)
        %figure('name',selected_images{i}),
        %hist(words_matrix{i})
        N = hist(words_matrix{i}, a);
        Nsum = sum(N);
        Nnorm = N/Nsum;
    end