function [centers, assignment] = build_vocab(data_matrix, clusters)
    [centers, assignment] = vl_kmeans(data_matrix, clusters);