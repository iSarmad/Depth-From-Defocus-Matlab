function [Mp,Mf]=maxfnf(FMo)

ROWS = length(FMo{1}(:,1));
COLS = length(FMo{1}(1,:));
Mp = zeros(ROWS,COLS);
Mf = zeros(ROWS,COLS);


for i = 1:ROWS
for j = 1:COLS
    tmp =-100;
    idxmax = 1;
    for idx = 1 : length(FMo)
       FMmax = max(tmp,FMo{idx}(i,j));
       if FMmax > tmp
        idxmax = idx;
       end
       tmp = FMmax;
    end
    Mf(i,j) = idxmax;
    Mp(i,j) = FMmax;
end
end
WSize =5;
MEANF = fspecial('sobel');
%Mf = imfilter(Mf, MEANF, 'replicate');

end