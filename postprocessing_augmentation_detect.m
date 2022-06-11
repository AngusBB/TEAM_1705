clc;close all;

imdsNormal = imageDatastore("All_Images");

trainingData = combine(imdsNormal);
%Augmentation
Inum = numel(imdsNormal.Files);

for i = 1 : 9
    augmentedTrainingData = transform(trainingData,@augmentData);
    
    augmentedData = cell(1,1);
    for k = 1 : Inum
        data = read(augmentedTrainingData);
        
        augmentedData{k} = data{1};

        [~, name, ~] = fileparts(imdsNormal.Files(k));
        imwrite(augmentedData{k}, 'augmentation/Detect_Image_Aug/' + append(name, '_', string(i), '.jpg'), 'jp2', 'Mode', 'lossless');


%         figure
%         imshow(augmentedData{k})

    end

    reset(augmentedTrainingData);


end

% =============================================================================
function data = augmentData(A)


data = cell(size(A));
    for ii = 1:size(A,1)
    
        I = A{ii,1};
        sz = size(I);
    
        if numel(sz) == 3 && sz(3) == 3
            I = jitterColorHSV(I, contrast=0.2, Hue=0.1, Saturation=0.2, Brightness=0.3);
        end
          
        data(ii,:) = {I};

    end
end