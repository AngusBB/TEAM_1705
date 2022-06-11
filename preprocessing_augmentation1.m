clc;close all;

path = 'OBJ_Train_Datasets/Train_Images';
path2 = [path, '/'];
imgpath = strcat(path2, string(gTruth_labeler.T_file));

imgDS = imageDatastore(imgpath);
bboxDS = boxLabelDatastore(gTruth_labeler(:,2:end));
segDS = imageDatastore("augmentation/mask");

trainingData = combine(imgDS,bboxDS,segDS);


%Augmentation

Inum = numel(imgDS.Files);

for i = 1 : 10
    augmentedTrainingData = transform(trainingData,@augmentData);
    
    augmentedData = cell(4,1);
    for k = 1 : Inum
        data = read(augmentedTrainingData);
        
        augmentedData{k} = data{1};
        compare = insertShape(data{1},'Rectangle',data{2},'Color','green','LineWidth',3);


        data{4} = im2gray(data{4});
        data{4}(data{4} == 1) = 0;
        data{4}(data{4} > 0) = 255;

        CC = bwconncomp(data{4});
        L = labelmatrix(CC);
        numObjects = max(L(:));


        Isize = size(augmentedData{k});
        [~, name, ~] = fileparts(imgDS.Files(k));
        imwrite(augmentedData{k}, 'augmentation/images/' + append(name, '_', string(i), '.jpg'), 'jp2', 'Mode', 'lossless');

        fileID = fopen('augmentation/labels/' + append(name, '_', string(i), '.txt'),'w');

        for j = 1 : numObjects

            [y, x] = ind2sub(CC.ImageSize, CC.PixelIdxList{j});
            LU_x = min(x);
            LU_y = min(y);
            RD_x = max(x);
            RD_y = max(y);
%             rectangle('Position', [LU_x, LU_y, RD_x - LU_x, RD_y - LU_y],'EdgeColor','r','LineWidth',2);
            compare = insertShape(compare, 'Rectangle', [LU_x, LU_y, RD_x - LU_x, RD_y - LU_y],'Color','red','LineWidth',3);

            a = (LU_x + (RD_x - LU_x)/2)/Isize(2);
            b = (LU_y + (RD_y - LU_y)/2)/Isize(1);
            c = (RD_x - LU_x)/Isize(2);
            d = (RD_y - LU_y)/Isize(1);
            fprintf(fileID, '0 %1.6f %1.6f %1.6f %1.6f\n', a, b, c, d);
            
        end

        fclose(fileID);

%         figure
%         imshow(compare)
% 
%         figure
%         imshow(data{4})

    
    end

    reset(augmentedTrainingData);

end

% =============================================================================
function data = augmentData(A)

data = cell(size(A));
for ii = 1:size(A,1)
    I = A{ii,1};
    bboxes = A{ii,2};
    labels = A{ii,3};

    mask = A{ii, 4};

    sz = size(I);

    if numel(sz) == 3 && sz(3) == 3
        I = jitterColorHSV(I, contrast=0.2, Hue=0.1, Saturation=0.2, Brightness=0.3);
    end
    
    % Randomly flip image.
    tform = randomAffine2d( ...
        XReflection=true, ...
        YReflection=true, ...
        Rotation=[-45 45], ...
        Scale=[1 1.5], ...
        XShear=[0 20], ...
        YShear=[0 20], ...
        XTranslation=[0 0], ...
        YTranslation=[0 0]);
%     tform = randomAffine2d( ...
%         XReflection=true);
%     disp(tform.T);
    rout = affineOutputView(sz,tform,BoundsStyle="centerOutput");
    I = imwarp(I,tform,OutputView=rout);
    mask = imwarp(mask, tform, OutputView=rout);

    
    % Apply same transform to bbox.
    [bboxes,indices] = bboxwarp(bboxes,tform,rout,OverlapThreshold=0.25);
    labels = labels(indices);
    
    % Return original data only when all boxes are removed by warping.
    if isempty(indices)

        data(ii,:) = A(ii,:);
    else
        data(ii,:) = {I,bboxes,labels,mask};
    end

end

end