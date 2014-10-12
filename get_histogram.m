function his = get_histogram(words_matrix, selected_images)
    % For every image, create histogram
    for i = 1:size(words_matrix,2)
        figure('name',selected_images{i}),
        hist(words_matrix{i})
        %hist(words_matrix(i,:))
    end
    his=0