% Parameters:   im = path to image
%               type_sift = {dense, key}
%               color_space = {gray, RGB, normalizedRGB, opponent}
%               sizes = scales at which dense sift features are extracted
%               (so only used for dense sift)
%               step = step in pixels at which dense sift features are
%               extracted (so only used for dense sift)
% Returns:      descriptors =  single if color_space is gray, otherwise list
%               of 3 descriptors

function descriptors = extract_features3(im, type_sift, color_space, dsift_sizes, dsift_step)   
    % Color image for different colorspaces
    im_color = imread(im);
    

    channels = size(im_color, 3);
    
    % Check if image is gray scale eventhough another color space was
    % needed. For now returns set of empty arrays
    if (channels == 1 && ~strcmp(color_space, 'gray'))
        descriptors = {[],[],[]};
        return
    end
    
    switch(type_sift)
        case('dense')
            switch(color_space)
                case('gray')
                    % Check if image is gray or rgb
                    if(channels == 1)
                        im_key = im2single(im_color);
                    else
                        im_key = im2single(rgb2gray(im_color));
                    end
                    [~, descriptors] = vl_phow(im_key, 'sizes', dsift_sizes, 'step', dsift_step);
                    descriptors = {descriptors};
                
                case('RGB')
                    % RGBSift (sift per color channel)
                    
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    
                    [~, first_descriptors] = vl_phow(im2single(R), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    [~, second_descriptors] = vl_phow(im2single(G), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    [~, third_descriptors] = vl_phow(im2single(B), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    descriptors = {first_descriptors, second_descriptors, third_descriptors};
                    
                    %[~, descriptors] = vl_phow(im2single(im_color), 'Sizes', dsift_sizes, 'Step', dsift_step, 'Color', 'rgb');
                    %descriptors = {descriptors};
                
                case('normalizedRGB')
                    % rgbSift (sift per normalized color channel)
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    total = R+G+B;
                    r = double(R./total);
                    g = double(G./total);
                    b = double(B./total);
                    
                    [~, first_descriptors] = vl_phow(im2single(r), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    [~, second_descriptors] = vl_phow(im2single(g), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    [~, third_descriptors] = vl_phow(im2single(b), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    descriptors = {first_descriptors, second_descriptors, third_descriptors};
                    
                    %[~, descriptors] = vl_phow(im2single(nRGB), 'Sizes', dsift_sizes, 'Step', dsift_step, 'Color', 'rgb');
                    %descriptors = {descriptors};
                
                case('opponent')
                    % opponentSift (sift in opponent color space)
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    first = (R-G)./(sqrt(2));
                    second = (R+G-(2*B))./(sqrt(6));
                    third = (R+G+B)./sqrt(3);
         
                    [~, first_descriptors] = vl_phow(im2single(first), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    [~, second_descriptors] = vl_phow(im2single(second), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    [~, third_descriptors] = vl_phow(im2single(third), 'Sizes', dsift_sizes, 'Step', dsift_step);
                    %[~, descriptors] = vl_phow(im2single(im_color), 'Sizes', dsift_sizes, 'Step', dsift_step, 'Color', 'opponent');
                    %descriptors = {descriptors};
                    descriptors = {first_descriptors, second_descriptors, third_descriptors};
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
                    descriptors = {descriptors};
                    
                case('RGB')
                    % RGBSift (sift per color channel)
                    R = im_color(:,:,1); % Red channel
                    G = im_color(:,:,2); % Green channel
                    B = im_color(:,:,3); % Blue channel
                    [~, R_descriptors] = vl_sift(im2single(R));
                    [~, G_descriptors] = vl_sift(im2single(G));
                    [~, B_descriptors] = vl_sift(im2single(B));
                    descriptors = {R_descriptors, G_descriptors, B_descriptors};
               
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
                    descriptors = {r_descriptors, g_descriptors, b_descriptors};
                
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
                    descriptors = {first_descriptors, second_descriptors, third_descriptors};
                
                otherwise
                   disp('ERROR: INVALID COLOR SPACE')
            end
        otherwise
            disp('ERROR: Invalid sift type')
    end
end