% Parameters:   im = path to image
%               type_sift = {dense, key}
%               color_space = {gray, RGB, normalizedRGB, opponent}
% Returns:      descriptors =  single if color_space is gray, otherwise list
%               of 3 descriptors

function descriptors = extract_features2(im, type_sift, color_space)   
    % Color image for different colorspaces
    im_color = imread(im);
    

    channels = size(im_color, 3);
    
    % Check if image is gray scale eventhough another color space was
    % needed. For now returns set of empty arrays
    if (channels == 1 && ~strcmp(color_space, 'gray'))
        descriptors = {[],[],[]}
        % OR MAYBE TURN COLOR SPACE TEMPORARILY TO GRAY??
        return
    end
    
   % Calculate descriptors for different types of color spaces using dense
    % or key based sift
    switch(color_space)
        case('gray')
            % Check if image is gray or rgb
            if(channels == 1)
                im_key = im2single(im_color);
            else
                im_key = im2single(rgb2gray(im_color));
            end
            switch(type_sift)
                case('dense')
                    [~, descriptors] = vl_dsift(im_key);
                case('key')
                    [~, descriptors] = vl_sift(im_key);
            end
            descriptors = {descriptors};
        case('RGB')
            % RGBSift (sift per color channel)
            R = im_color(:,:,1); % Red channel
            G = im_color(:,:,2); % Green channel
            B = im_color(:,:,3); % Blue channel
            switch(type_sift)
                case('dense')
                    [~, R_descriptors] = vl_dsift(im2single(R));
                    [~, G_descriptors] = vl_dsift(im2single(G));
                    [~, B_descriptors] = vl_dsift(im2single(B));
                case('key')
                    [~, R_descriptors] = vl_sift(im2single(R));
                    [~, G_descriptors] = vl_sift(im2single(G));
                    [~, B_descriptors] = vl_sift(im2single(B));
            end
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
            switch(type_sift)
                case('dense')
                    [~, r_descriptors] = vl_dsift(im2single(r));
                    [~, g_descriptors] = vl_dsift(im2single(g));
                    [~, b_descriptors] = vl_dsift(im2single(b));
                case('key')
                    [~, r_descriptors] = vl_sift(im2single(r));
                    [~, g_descriptors] = vl_sift(im2single(g));
                    [~, b_descriptors] = vl_sift(im2single(b));
            end
            descriptors = {r_descriptors, g_descriptors, b_descriptors};
        case('opponent')
            % opponentSift (sift in opponent color space)
            R = im_color(:,:,1); % Red channel
            G = im_color(:,:,2); % Green channel
            B = im_color(:,:,3); % Blue channel
            first = (R-G)./(sqrt(2));
            second = (R+G-(2*B))./(sqrt(6));
            third = (R+G+B)./sqrt(3);
            switch(type_sift)
                case('dense')
                    [~, first_descriptors] = vl_dsift(im2single(first));
                    [~, second_descriptors] = vl_dsift(im2single(second));
                    [~, third_descriptors] = vl_dsift(im2single(third));
                case('key')
                    
                        % TODO: Sometimes, one or multiple descriptor
                        % matrices from key sift using opponent color space
                        % are empty, making cat() throw an error. Error
                        % encountered with gray images and images with a
                        % lot of the same colors.                    
                    [~, first_descriptors] = vl_sift(im2single(first));
                    [~, second_descriptors] = vl_sift(im2single(second));
                    [~, third_descriptors] = vl_sift(im2single(third));
            end
            descriptors = {first_descriptors, second_descriptors, third_descriptors};
        otherwise
            disp('ERROR: INVALID COLOR SPACE')
    end