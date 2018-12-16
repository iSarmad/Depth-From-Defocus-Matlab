function [FMos] =  FM(wimages)
N = length(wimages);
FMos{N,1} = [];
% Taking Fourier transform of I
for idx = 1:N
I = rgb2gray(wimages{idx,1});
I = im2double(I);
%% Laplacian Focus measure
WSize =2;
MEANF = fspecial('average',[WSize WSize]);
%GL = fspecial('log',[5 5],1000);
H = fspecial('laplacian',0.1);%
%H = fspecial('sobel');
%FMo = imfilter(I,GL,'replicate');
FMo = imfilter(I,H,'replicate');
%FMo = imfilter(FMo, MEANF, 'replicate');


%% Square of Laplacian Focus measure
% WSize =2;
% MEANF = fspecial('average',[WSize WSize]);
% M = [-1 2 -1];
% Lx = imfilter(I, M, 'replicate', 'conv');
% Ly = imfilter(I, M', 'replicate', 'conv');
% FMo = abs(Lx) + abs(Ly);
% %FMo = imfilter(FMo, MEANF, 'replicate');
% %colormap jet;image(im2uint8(FMo));shg
FMos{idx,1} = FMo;
end

end
