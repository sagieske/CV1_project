function descriptors = extract_features(im, type_sift)
    im_key = im2single(rgb2gray(imread(im)));
    im_color = imread(im);
    
    switch(type_sift)
        case('dense')
        % dense sift extraction
        [dense_frames, descriptors] = vl_dsift(im_key);
        case('key')
        % key points sift extraction
        [key_frames, descriptors] = vl_sift(im_key);
        case('RGB')
        % RGBSift (sift per color channel)
        R = im_color(:,:,1); % Red channel
        G = im_color(:,:,2); % Green channel
        B = im_color(:,:,3); % Blue channel
        [R_frames, R_descriptors] = vl_sift(im2single(R));
        [G_frames, G_descriptors] = vl_sift(im2single(G));
        [B_frames, B_descriptors] = vl_sift(im2single(B));
        descriptors = cat(3, R_descriptors, G_descriptors, B_descriptors);
        case('normalizedRGB')
        % rgbSift (sift per normalized color channel)
        total = R+G+B;
        r = double(R./total);
        g = double(G./total);
        b = double(B./total);
        [r_frames, r_descriptors] = vl_sift(im2single(r));
        [g_frames, g_descriptors] = vl_sift(im2single(g));
        [b_frames, b_descriptors] = vl_sift(im2single(b));
        descriptors = cat(3, r_descriptors, g_descriptors, b_descriptors);
        case('opponent')
        % opponentSift (sift in opponent color space)
        first = (R-G)./(sqrt(2));
        second = (R+G-(2*B))./(sqrt(6));
        third = (R+G+B)./sqrt(3);
        [first_frames, first_descriptors] = vl_sift(im2single(first));
        [second_frames, second_descriptors] = vl_sift(im2single(second));
        [third_frames, third_descriptors] = vl_sift(im2single(third));
        descriptors = cat(3, first_descriptors, second_descriptors, third_descriptors);
    end