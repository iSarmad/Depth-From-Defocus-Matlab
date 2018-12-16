function I = graphcut(Mf,thresD,thresS,G)

addpath('gco-v3.0\matlab');%D:\Desktop\
[x,y] = size(Mf);

sites = x*y;
labels = max(max(Mf));
  
Datacost = int32(zeros(labels,sites));
% Datacost
%thresD = 6;
%thresS= 18;
%G = 1;

for idx = 1:labels
for i = 1 : x
    for j = 1: y
        sitesn = y *(i-1) +j;
        Datacost(idx,sitesn) = abs(Mf(i,j)-(idx));
        if (Datacost(idx,sitesn) > thresD)
         Datacost(idx,sitesn) = thresD;
        end
     end
end
end

% Smoothcost
Smoothcost = int32(zeros(labels,labels));

for i = 1 : labels
    for j = 1:labels
        if i==j
        else
            if(j>i)
                Smoothcost(i,j) = (j-i);
               if(Smoothcost(i,j) > thresS)
                Smoothcost(i,j) = thresS;
               end
            else
                Smoothcost(i,j) = (i-j);
                if(Smoothcost(i,j) > thresS)
                    Smoothcost(i,j) = thresS;
                end
            end
        end
    end
end

% Neightbours 

cons = x*y*4 -2*(x-2)-2*(y-2)-4*2;
si = zeros(1,cons);
sj = zeros(1,cons);
v = zeros(1,cons);
idn =1;
for idx = 1 : sites
    in = floor((idx-1)/y)+1;
    jn = idx-(y)*floor((idx-1)/y);
    jn1 = jn-1;
    if(jn1>0)
        sitesn = y *(in-1) +jn1;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  2.0;
        idn = idn+1;
    end
    
    jn1 = jn-2;
    if(jn1>0)
        sitesn = y *(in-1) +jn1;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  1.0;
        idn = idn+1;
    end
    
    
    in2 = in-1;
    if(in2>0)
        sitesn = y *(in2-1) +jn;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  2.0;
        idn = idn+1;
    end
    
    
    
    in2 = in-2;
    if(in2>0)
        sitesn = y *(in2-1) +jn;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  1.0;
        idn = idn+1;
    end
    
    
    
    jn3 = jn+1;
    if(jn3<=y)
        sitesn = y *(in-1) +jn3;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  2.0;
        idn = idn+1;
    end
    
    
    jn3 = jn+2;
    if(jn3<=y)
        sitesn = y *(in-1) +jn3;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  1.0;
        idn = idn+1;
    end
    
    
    
    in4 = in+1;
    if(in4<=x)
        sitesn = y *(in4-1) +jn;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  2.0;
        idn = idn+1;
    end
    
    in4 = in+2;
    if(in4<=x)
        sitesn = y *(in4-1) +jn;
        si(1,idn) =  idx;
        sj(1,idn) =  sitesn;
        v(1,idn) =  1.0;
        idn = idn+1;
    end
    
end
 
S = sparse(si,sj,v,sites,sites);

clear jn1 in2 jn3 in4 i j idx 

h = GCO_Create(sites,labels);% hw x 32
GCO_SetDataCost(h,Datacost);
GCO_SetSmoothCost(h,G*Smoothcost);
GCO_SetNeighbors(h,S);
GCO_Expansion(h);
nlabels = GCO_GetLabeling(h);

I =zeros(x,y);
for idx = 1 : sites
    in = floor((idx-1)/y)+1;
    jn = idx-(y)*floor((idx-1)/y);
    I(in,jn) = nlabels(idx,1);
end

GCO_Delete(h);


end