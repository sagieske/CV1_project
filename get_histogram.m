function his = get_histogram(words_matrix)
    for i = 1:size(words_matrix,1)
        figure,
        hist(words_matrix(i,:))
    end
    his=0