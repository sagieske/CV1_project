% Parameters:   im = path to image
%               type_sift = {dense, key}
%               color_space = {gray, RGB, normalizedRGB, opponent}
%               sizes = scales at which dense sift features are extracted
%               (so only used for dense sift)
%               step = step in pixels at which dense sift features are
%               extracted (so only used for dense sift)
% Returns:      descriptors = vector of descriptors for the image

function descriptors = extract_features3(im, type_sift, color_space, dsift_sizes, dsift_step)   
    % Color image for different colorspaces
    im_color = imread(im);
    channels = size(im_color, 3);
    % Check if image is gray scale eventhough another color space was
    % needed. For now returns set of empty arrays
    if (channels == 1 && ~strcmp(color_space, 'gray'))
        descriptors = [];
        return
    end
    
    switch(type_sift)
        case('dense')
            switch(color_space)
                case('gray')
                    % Check if image is gray or rgb, if needed convert to
                    % grayscale
                    if(channels == 1)
                        im_key = im2single(im_color);
                    else
                        im_key = im2single(rgb2gray(im_color));
                    end
                    % Run sift with grayscale image
                    [~, descriptors] = vl_phow(im_key, 'sizes', dsift_sizes, 'step', dsift_step);
                
                case('RGB')
                    % RGBSift (sift per color channel)
                    [~, descriptors] = vl_phow(im2single(im_color), 'sizes', dsift_sizes, 'step', dsift_step, 'color', 'rgb');
                    
                case('normalizedRGB')
                    % rgbSift (sift per normalized color channel)
                    % First, the image is normalized and then RGB sift is
                    % run over the normalized image
                    img = im2single(im_color);
                    nm = img(:, :, 1) + img(:, :, 2) + img(:, :, 3);
                    nm(nm == 0) = 1;
                    img(:, :, 1) = img(:, :, 1) ./ nm;
                    img(:, :, 2) = img(:, :, 2) ./ nm;
                    img(:, :, 3) = img(:, :, 3) ./ nm;
                    img(nm == 0) = 1/sqrt(3);           
                    [~, descriptors] = vl_phow(img, 'Sizes', dsift_sizes, 'Step', dsift_step, 'Color', 'rgb');
                    
                case('opponent')
                    % opponentSift (sift in opponent color space)
                    [~, descriptors] = vl_phow(im2single(im_color), 'Sizes', dsift_sizes, 'Step', dsift_step, 'Color', 'opponent');
            end
        case('key')
            switch(color_space) 
               case('gray')
                    % Check if image is gray or rgb
                    if(channels == 1)
                        im_key = im2single(im_color);
                    else
                        im_key = im2single(rgb2gray(im_color));
                    end
                    [~, descriptors] = vl_sift(im_key);
                    %descriptors = {descriptors};
                    
                case('RGB')
                    % RGBSift (sift per color channel)
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    [~, R_descriptors] = vl_sift(im2single(R));
                    [~, G_descriptors] = vl_sift(im2single(G));
                    [~, B_descriptors] = vl_sift(im2single(B));
                    descriptors = [R_descriptors G_descriptors B_descriptors];
               
                case('normalizedRGB')
                    % rgbSift (sift per normalized color channel)
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    total = R+G+B;
                    r = double(R./total);
                    g = double(G./total);
                    b = double(B./total);
                    [~, r_descriptors] = vl_sift(im2single(r));
                    [~, g_descriptors] = vl_sift(im2single(g));
                    [~, b_descriptors] = vl_sift(im2single(b));
                    descriptors = [r_descriptors g_descriptors b_descriptors];
                
                case('opponent')
                    % opponentSift (sift in opponent color space)
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    first = (R-G)./(sqrt(2));
                    second = (R+G-(2*B))./(sqrt(6));
                    third = (R+G+B)./sqrt(3);              
                    [~, first_descriptors] = vl_sift(im2single(first));
                    [~, second_descriptors] = vl_sift(im2single(second));
                    [~, third_descriptors] = vl_sift(im2single(third));
                    descriptors = [first_descriptors second_descriptors third_descriptors];
            
                otherwise
                   disp('ERROR: INVALID COLOR SPACE')
            end
        otherwise
            disp('ERROR: Invalid sift type')
    end
end