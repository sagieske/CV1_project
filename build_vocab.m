function [centers, assignment] = build_vocab(data_matrix, clusters)
    % Center has same number of rows as data_matrix (128) and clustersize number of columns
    % Assignment is a row vector specifying assignments of data_matrix to
    % centers
    [centers, assignment] = vl_kmeans(data_matrix, clusters);