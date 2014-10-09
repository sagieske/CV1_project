% Parameters: im = path to image
%             type_sift = {dense, key}
%             color_space = {gray, RGB, normalizedRGB, opponent}

function descriptors = extract_features2(im, type_sift, color_space)   
    % Color image for different colorspaces
    im_color = imread(im);
    
    % Calculate descriptors for different types of color spaces using dense
    % or key based sift
    
    % TODO: Maybe add a check in RGB. nRGB and opponent to check whether the
    % image is really RGB and not accidentially grayscale???
    % -> Update: check implemented, not sure if it really is required.
    % Please review.
    channels = size(im_color, 3);
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
        case('RGB')
            % Check if input image is in RGB
            if(channels == 3)
                % RGBSift (sift per color channel)
                R = im_color(:,:,1); % Red channel
                G = im_color(:,:,2); % Green channel
                B = im_color(:,:,3); % Blue channel
                switch(type_sift)
                    case('dense')
                        [~, R_descriptors] = vl_dsift(im2single(R));
                        [~, G_descriptors] = vl_dsift(im2single(G));
                        [~, B_descriptors] = vl_dsift(im2single(B));
                        descriptors = cat(3, R_descriptors, G_descriptors, B_descriptors);
                    case('key')
                        [~, R_descriptors] = vl_sift(im2single(R));
                        [~, G_descriptors] = vl_sift(im2single(G));
                        [~, B_descriptors] = vl_sift(im2single(B));
                        descriptors = cat(3, R_descriptors, G_descriptors, B_descriptors);
                end
            else
                descriptors = [];
            end
        case('normalizedRGB')
            % Check if input image is in RGB
            if(channels == 3)
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
                        descriptors = cat(3, r_descriptors, g_descriptors, b_descriptors);
                    case('key')
                        [~, r_descriptors] = vl_sift(im2single(r));
                        [~, g_descriptors] = vl_sift(im2single(g));
                        [~, b_descriptors] = vl_sift(im2single(b));
                        descriptors = cat(3, r_descriptors, g_descriptors, b_descriptors);
                end
            else
                descriptors = [];
            end
        case('opponent')
            % Check if the input image is in RGB
            if(channels == 3)
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
                        descriptors = cat(3, first_descriptors, second_descriptors, third_descriptors);
                    case('key')
                        
                        % TODO: Sometimes, one or multiple descriptor
                        % matrices from key sift using opponent color space
                        % are empty, making cat() throw an error. Error
                        % encountered with gray images and images with a
                        % lot of the same colors.
                        
                        
                        [~, first_descriptors] = vl_sift(im2single(first));
                        [~, second_descriptors] = vl_sift(im2single(second));
                        [~, third_descriptors] = vl_sift(im2single(third));
                        descriptors = cat(3, first_descriptors, second_descriptors, third_descriptors);
                end
            else
                descriptors = [];
            end
    end