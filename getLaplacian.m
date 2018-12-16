
function L = getLaplacian(I, r)
% 
% this function computes the matting laplacian
% adapted from Levin's code for the following paper
%
% A Closed-Form Solution to Natural Image Matting
% 
% Shaojie Zhuo @ 2011
%

eps=0.0000001;
[h w c] = size(I);
N = boxfilter(ones(h, w), r);

meanI_r = boxfilter(I(:, :, 1), r) ./ N;
meanI_g = boxfilter(I(:, :, 2), r) ./ N;
meanI_b = boxfilter(I(:, :, 3), r) ./ N;

% variance of I in each local patch
%           rr, rg, rb
%   Sigma = rg, gg, gb
%           rb, gb, bb
varI_rr = boxfilter(I(:, :, 1).*I(:, :, 1), r) ./ N - meanI_r .*  meanI_r;
varI_rg = boxfilter(I(:, :, 1).*I(:, :, 2), r) ./ N - meanI_r .*  meanI_g;
varI_rb = boxfilter(I(:, :, 1).*I(:, :, 3), r) ./ N - meanI_r .*  meanI_b;
varI_gg = boxfilter(I(:, :, 2).*I(:, :, 2), r) ./ N - meanI_g .*  meanI_g;
varI_gb = boxfilter(I(:, :, 2).*I(:, :, 3), r) ./ N - meanI_g .*  meanI_b;
varI_bb = boxfilter(I(:, :, 3).*I(:, :, 3), r) ./ N - meanI_b .*  meanI_b;

wr = (2*r+1) * (2*r+1);
cc = zeros(h,w);
tlen=sum(sum(1-cc(r+1:end-r,r+1:end-r)))*(wr^2);
M_idx = reshape([1:h*w], h, w);
vals=zeros(tlen,1);
len = 0;
for y=1+r:h-r
    for x=1+r:w-r
        Sigma = [varI_rr(y, x), varI_rg(y, x), varI_rb(y, x);
            varI_rg(y, x), varI_gg(y, x), varI_gb(y, x);
            varI_rb(y, x), varI_gb(y, x), varI_bb(y, x)];
        meanI = [meanI_r(y,x), meanI_g(y,x), meanI_b(y,x)];
     
        Sigma = Sigma + eps * eye(3);
        win_idx = M_idx(y-r:y+r,x-r:x+r);
        win_idx=win_idx(:);
        
        winI=I(y-r:y+r,x-r:x+r,:);
        
        winI=reshape(winI,wr,c);
        
        % repmat is too slow, replace repmat with indexing
        % meanI(ones(wr,1),:) <=> repmat(meanI,wr,1) 
        winI=winI-meanI(ones(wr,1),:);
        
        tvals=(1+winI*inv(Sigma)*winI')/wr;
        
        % win_idx(:,ones(wr,1))<=>repmat(win_idx,1,wr)
        row_idx(1+len:wr^2+len)=reshape(win_idx(:,ones(wr,1)),wr^2,1);
        
        % t(ones(wr,1),:)<=>repmat(win_idx',wr,1)
        t = win_idx';
        col_idx(1+len:wr^2+len)=reshape(t(ones(wr,1),:),wr^2,1);
        
        vals(1+len:wr^2+len)=tvals(:);
        len=len+wr^2;
    end
end

vals=vals(1:len);
row_idx=row_idx(1:len);
col_idx=col_idx(1:len);
L=sparse(row_idx,col_idx,vals,h*w,h*w);
sumL=sum(L,2);
L=spdiags(sumL(:),0,h*w,h*w)-L;

