function Seq = loadImages(imgPath, imgType)
    %imgPath = 'path/to/images/folder/';
    %imgType = '*.png'; % change based on image type
    images  = dir([imgPath imgType]);
    
        

    
    
    N = length(images);
    X = cell(N,1);
    
    for idx = 1:N
        X(idx,1) =  cellstr(images(idx).name);
        
    end
    
    
    X =natsortfiles(X);
   
    for idx = 1:N
        images(idx).name = char(X(idx));
    end
    
    
    
    
    % check images
    if( ~exist(imgPath, 'dir') || N<1 )
        display('Directory not found or no matching images found.');
    end

    % preallocate cell
    Seq{N,1} = [];

    for idx = 1:N
        Seq{idx} = imread([imgPath images(idx).name]);
    end
end