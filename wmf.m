function out = wmf(I,W,mask)
x = size(I,1);
y = size(I,2);
out = zeros(x,y);

paddedi=zeros(size(I)+2*fix(mask/2));
paddedw=zeros(size(W)+2*fix(mask/2));

for i=1:x
    for j=1:y
        paddedi(i+fix(mask/2),j+fix(mask/2))=I(i,j);
        paddedw(i+fix(mask/2),j+fix(mask/2))=W(i,j);
    
    end
end


for a = 1:x
    for b = 1:y
        %Creating the window array
        win=zeros(mask*mask,1);
        weight =zeros(mask*mask,1);
        i=1;
      
        %Adding elements to the window
        for c=1:mask
            for d=1:mask
                win(i)=paddedi(a+c-1,b+d-1);
                weight(i)=paddedw(a+c-1,b+d-1);
                i=i+1;
            end
        end
        
        W = weight;
        D = win;
        
        epsilon =1e-5;
        WSum = sum(W(:));
        W = W / (WSum+epsilon);

        % (line by line) transformation of the input-matrices to line-vectors
        d = reshape(D',1,[]);   
        w = reshape(W',1,[]);  

        % sort the vectors
        A = [d' w'];
        ASort = sortrows(A,1);

        dSort = ASort(:,1)';
        wSort = ASort(:,2)';

        sumVec = [];    % vector for cumulative sums of the weights
        for i = 1:length(wSort)
            sumVec(i) = sum(wSort(1:i));
        end

        wMed = [];      
        j = 0;         

        while isempty(wMed)
            j = j + 1;
        %    disp(a);
         %   disp(b);
            if max(sumVec)<0.5
                wMed = dsort(1);
            else
                if sumVec(j) >= 0.5
                wMed = dSort(j);    % value of the weighted median
            
                end
            end
        end
        
        %Finding the median of the window by sorting the 1D array
        
        out(a,b)=wMed;
    end
end



end