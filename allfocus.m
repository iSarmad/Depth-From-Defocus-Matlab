function [FIn,FIo] = allfocus(wimages,GC,Mf)

[x,y] = size(wimages{1}(:,:,1));
%x = 720;
%y = 1280;
FIn =zeros(x,y,3);
FIo =zeros(x,y,3);

for i = 1:x
    for j = 1:y
        idx = GC(i,j);
        FIn(i,j,:) = wimages{idx}(i,j,:);
    end
end
            

for i = 1:x
    for j = 1:y
        idx = Mf(i,j);
        FIo(i,j,:) = wimages{idx}(i,j,:);
    end
end

end