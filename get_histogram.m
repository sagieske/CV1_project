function his = get_histogram(words_matrix)
    % For every image, create histogram
    for i = 1:size(words_matrix,2)
        figure,
        hist(words_matrix{1})
        %hist(words_matrix(i,:))
    end
    his=0