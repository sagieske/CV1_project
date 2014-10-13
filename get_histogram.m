function his = get_histogram(words_matrix, selected_images)
    % For every image, create histogram
    for i = 1:size(words_matrix,2)
        size(words_matrix{i})
        figure('name',selected_images{i}),
        %hist(words_matrix{i})
        bar(hist(words_matrix{i}) ./ sum(hist(words_matrix{i})))
        %hist(words_matrix(i,:))
    end
    his=0