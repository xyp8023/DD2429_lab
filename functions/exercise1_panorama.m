
% Method:   Generate one image out of multiple images. All images are from
%           a camera with the same (!) center of projection. All the images 
%           are registered to one reference view.

clear all                   % Remove all old variables
close all                   % Close all figures
clc                         % Clear the command window
addpath( genpath( '../' ) );% Add paths to all subdirectories of the parent directory

LOAD_DATA           = false;
REFERENCE_VIEW      = 3;
CAMERAS             = 3;

% image_names_file    = '../images/names_images_kthsmall.txt';
% points2d_file       = '../data/data_kth.mat';

% image_names_file    = '../images/names_images_kth.txt';
% points2d_file       = '../data/data_kth_large.mat';

image_names_file    = '../images/names_images_kthsmall.txt';
points2d_file       = '../data/data_kth_4points.mat';

name_panorama       = '../images/panorama_image.jpg';




[images, name_loaded_images] = load_images_grey( image_names_file, CAMERAS );

% Load the clicked points if they have been saved,
% or click some new points:
if LOAD_DATA 
    load( points2d_file );
else
    points2d = click_multi_view( images ); %, C, data, 0 ); % for clicking and displaying data
    save( points2d_file, 'points2d' );
end


%% Compute homographies
% Determine all homographies to a reference view. We have:
% point in REFERENCE_VIEW = homographies(:,:,c) * point in image c.
% Remember, you have to set homographies{REFERENCE_VIEW} as well.
save( points2d_file, 'points2d' );
homographies = zeros(3,3,CAMERAS); 

%-------------------------
% TODO: FILL IN THIS PART

% % normalized
% norm_mat = compute_normalization_matrices( points2d );
% points2d_normalized = zeros(size(points2d));
% homographies_normalized = zeros(3, 3, CAMERAS);
% norm_mat_ref = norm_mat(:,:,REFERENCE_VIEW);
% for c=1:CAMERAS
%     points2d_normalized(:,:,c) = norm_mat(:,:,c) * points2d(:,:,c);
% end
% for c=1:CAMERAS
%     points_ref = points2d_normalized(:,:,REFERENCE_VIEW);
%     points_c   = points2d_normalized(:,:,c);
%     homographies_normalized(:,:,c) = compute_homography( points_ref, points_c );
% %     homographies(:,:,c)= homographies_normalized(:,:,c)\norm_mat_ref* norm_mat(:,:,c);
%     homographies(:,:,c)= pinv(norm_mat_ref)* homographies_normalized(:,:,c)* norm_mat(:,:,c) ;
% end


% non-normalized
for c=1:CAMERAS
    points_ref = points2d(:,:,REFERENCE_VIEW);
    points_c   = points2d(:,:,c);
    homographies(:,:,c) = compute_homography( points_ref, points_c );
end


for c = 1:CAMERAS
    
    [error_mean error_max] = check_error_homographies( ...
      homographies(:,:,c), points2d(:,:,c), points2d(:,:,REFERENCE_VIEW) );
 
    fprintf( 'Between view %d and ref. view; ', c );
    fprintf( 'average error: %5.2f; maximum error: %5.2f \n', error_mean, error_max );
end


%% Generate, draw and save panorama

panorama_image = generate_panorama( images, homographies );

figure;  
show_image_grey( panorama_image );
save_image_grey( name_panorama, panorama_image );
