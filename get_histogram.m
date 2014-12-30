% Function creates histograms from visual words
function normalized_matrix = get_histogram(words_matrix)
    % For every image, create histogram
    a = 1:200;
    normalized_matrix = [];
    for i = 1:size(words_matrix,2)
        N = hist(words_matrix{i}, a);
        Nsum = sum(N);
        Nnorm = N/Nsum;
        normalized_matrix = cat(1, normalized_matrix, Nnorm);
    
    %    desc = single(words_matrix{i});
    %    D = vl_alldist2(words_matrix, desc);
    %    [~, d] = min(D);
    %    cent = 1:size(words_matrix, 2)
    %    cnts = hist(d, cent);
        
     %   hist = cnts ./ sum(cnts);
    
    end
end
    