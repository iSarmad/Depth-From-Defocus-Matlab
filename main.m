clear all;
clc;
close all;
%% STEP1: DATA LOADING AND IMAGE ALIGNMENT
dataSet =1; %1 for Keyboard, 2 for Balls
if(dataSet==1) % Keyboard
    ref = 32; %Template/ Reference Image Selection for Alignment
    dpath = 'PA1_keyboard_aligned\';%PA1_keyboard_aligned PA1_balls_aligned
    upath = 'PA1_dataset2_keyboard\'; %PA1_dataset2_keyboard\ PA1_dataset1_balls
else % Balls
    ref = 25; %Template/ Reference Image Selection for Alignment
    dpath = 'PA1_balls_aligned\';%PA1_keyboard_aligned PA1_balls_aligned
    upath = 'PA1_dataset1_balls\'; %PA1_dataset2_keyboard\ PA1_dataset1_balls
end

thresData = 6; %6% Data Cost Threshold Selection for Graph Cut
thresSmooth = 32;%18 % Smooth Cost Threshold Selection for Graph Cut
G =1; % Smooth Cost Gain Selection for Graph Cut
mask = 3; %mask size for WMF filter

% Parameters for Extra Credits
Sthres = 0.09; % Sparse Threshold 
lambda = 0.001; % Lambda for Matting Laplacian

path = strcat(dpath,num2str(ref),'\');

if(exist(path))
    disp('Using Saved Dataset')
    type = '*.jpg';
    wimages= loadImages(path,type);
else
    disp('Generating New Dataset')
    type = '*.jpg';
    images= loadImages(upath,type);
    wimages = falign(images,ref,dpath);
end

%% STEP 2: FOCUS MEASURE ESTIMATION 
FMo = FM(wimages); % Finding focus measure of warped images

% DISPLAY IMAGE INPUT FOR SANITY CHECK 
idx = 25; % Image Number to Display
figure(1)
colormap(gray(255));
image(rgb2gray(wimages{idx}))
title('Input image')
axis off

% DISPLAYING FOCUS MEASURE ONE IMAGE ONLY
figure(2)
imagesc(im2uint8(FMo{idx})); 
colormap jet
title('Processed image')
axis off

% INITIAL FOCUS MAP GENERATION 
[Mp,Mf] = maxfnf(FMo);
figure(3)
imagesc(Mf); %Displaying the absolute value of processed image
colormap jet
title('Processed image')
axis off 

%% STEP3: GRAPH CUT GENERATION
GC = graphcut(Mf,thresData,thresSmooth,G);
figure(4)
imagesc(GC); %Displaying the absolute value of processed image
colormap jet;colorbar;
title('Graph Cut')
axis off

%% STEP4: ALL IN FOCUS IMAGE
[FIn,FIo] = allfocus(wimages,GC,Mf);

figure(5)
colormap(gray(255));
image(rgb2gray( im2uint8(FIn/255)))
title('ALL FOCUS New (Using Graph Cut Output)')
axis off

figure(6)
colormap(gray(255));
image(rgb2gray(im2uint8(FIo/255)))
title('ALL FOCUS Old (Using Initial Focus Map)')
axis off

%% STEP5: DEPTH REFINEMENT VIA Weighted Median Filter
WMF = wmf(GC,rgb2gray(im2uint8(FIn/255)),mask);

figure(7)
imagesc(WMF)
colormap jet;
%imshow(I,imagemap)
%imagesc(I);colormap default
title('Refinement: WMF Graphcut')
axis off

%% Extra Credit


x = size(Mp,1);
y = size(Mp,2);
I=FIn/255;

figure(8)
colormap(gray(255));
imagesc(rgb2gray(im2uint8(FIn/255)))%im2uint8(FIn/255)
title('All in Focus Input Image')
axis off

% generation of sparse focus map
for i = 1 : size(Mf,1)
    for j = 1: size(Mf,2)
    if(Mp(i,j)<Sthres)%&&Mf(i,j)<thres1
        Mf(i,j) = 0;
    end
    end
end

figure(9)
imagesc(Mf);colorbar;colormap jet;%im2uint8(FIn/255)
title('Sparse Focus Map')
axis off


mI=Mf/32;
sizeI=x*y;
constsMap=mI>0.0001;
sparseDMap = mI.*constsMap;
L=getLaplacian(I,1);
D=spdiags(constsMap(:),0,sizeI,sizeI);
out=(L+lambda*D)\(lambda*D*sparseDMap(:));
alpha=reshape(out,x,y);


figure(10)
colormap(gray(255));
imagesc(alpha);colorbar;colormap jet;
title('Focus Map (Matting Laplacian)')
axis off


gw=5;
aw = 5;
alpha_a = 32*alpha/max(max(alpha));
filt1 = (gw*GC+aw*(alpha_a))/(gw+aw);
figure(11)
colormap(gray(255));
imagesc(filt1);colorbar;colormap jet;
title('Focus Map ( Matting Laplacian + Graph Cut)')
axis off
