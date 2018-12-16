clear all;
clc
close all

path = 'D:\Desktop\PA1\PA1_dataset2_keyboard\';
type = '*.jpg';
images= loadImages(path,type);

%wimages = falign(images,1);


%% Load and show images
% Read initial image <-> template pair

img= images{32};%imread('textImage.png');
tmp= images{1};%imread('textTemplate.png');
figure;imagesc(rgb2gray(tmp-img));colormap jet;shg

transform = 'affine'; % it can be approximated by euclidean as well

% Plot both of these images
figure;image(img);title('Image','Fontsize',14);
figure;imshow(tmp);title('Template','Fontsize',14);

%% Feature-based alignment
% Extract SURF descriptors
[d1, l1]=iat_surf(img);
[d2, l2]=iat_surf(tmp);

% Match keypoints
%[map, matches, imgInd, tmpInd]=iat_match_features(d1,d2,.7);
[map, matches, imgInd, tmpInd]=iat_match_features_mex(d1,d2,.7);

ptsA=l1(imgInd,1:2);
ptsB=l2(tmpInd,1:2);

%Least-Square
LSWarp = iat_get_affine(iat_homogeneous_coords(ptsB'),iat_homogeneous_coords(ptsA'));


% RANSAC
[inliers, ransacWarp]=iat_ransac(iat_homogeneous_coords(ptsB'),iat_homogeneous_coords(ptsA'),...
transform,'tol',.05, 'maxInvalidCount', 15);

%% Plot results
% Plot initial correspondences
% iat_plot_correspondences(img,tmp,ptsA',ptsB');
% title('Initial correspondences','Fontsize',14);

%Plot filtered correspondences
iat_plot_correspondences(img,tmp,ptsA(inliers,:)',ptsB(inliers,:)');
title('RANSAC-filtered correspondences','Fontsize',14);

% Compute the warped image and visualize the error
[wimage, support] = iat_inverse_warping(img, ransacWarp, transform, 1:size(tmp,2),1:size(tmp,1));

% Compute the warped image and visualize the error
[wimageLS, supportLS] = iat_inverse_warping(img, LSWarp, transform, 1:size(tmp,2),1:size(tmp,1));




%plot the warped image
figure;imshow(uint8(wimage)); title('Warped image by feature-based alignment (RANSAC)', 'Fontsize', 14);

%plot the warped image
% figure;imshow(uint8(wimageLS)); title('Warped image by feature-based alignment (ls)', 'Fontsize', 14);
% 


% % visualize the error
% [imdiff, grayerror] = iat_error2gray(tmp,wimage,support);
% figure;imshow(grayerror);colormap default; title('Error of RANSAC feature-based alignment ', 'Fontsize', 14);
% 

figure;imagesc(rgb2gray(tmp-uint8(wimage))); title('Warped image by feature-based alignment (RANSAC)', 'Fontsize', 14);
colormap jet;shg


% figure;imagesc(rgb2gray(tmp-uint8(wimageLS))); title('Warped image by feature-based alignment (ls)', 'Fontsize', 14);
% colormap jet;shg