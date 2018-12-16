function wimages = falign(images,ref,path)
 wimages{length(images),1} = [];
 transform = 'affine';
 
 addpath('IAT_v0.9.3\IAT_v0.9.3');%D:\Desktop\
 iat_setup;
 
 path = strcat(path,num2str(ref),'/');
 tmp= images{ref};% Choose the Template
 if ~exist(path, 'dir')
  mkdir(path);
 end
 for i = 1: length(images)
 disp(i)
 [d1, l1]=iat_surf(images{i});
 [d2, l2]=iat_surf(tmp);
 [map, matches, imgInd, tmpInd]=iat_match_features_mex(d1,d2,.7);
 ptsA=l1(imgInd,1:2);
 ptsB=l2(tmpInd,1:2);
 
 % RANSAC
[inliers, ransacWarp]=iat_ransac(iat_homogeneous_coords(ptsB'),iat_homogeneous_coords(ptsA'),...
transform,'tol',.05, 'maxInvalidCount', 100);

[wimage, support] = iat_inverse_warping(images{i}, ransacWarp, transform, 1:size(tmp,2),1:size(tmp,1));
 wimages{i,1} = uint8(wimage);
 imwrite(uint8(wimage), strcat(path,num2str(i),'.jpg'))
 end
 
end