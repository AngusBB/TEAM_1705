clc;close all;

path = 'OBJ_Train_Datasets/Train_Images';
path2 = [path, '/'];
imgpath = strcat(path2, string(gTruth_labeler.T_file));

imgDS = imageDatastore(imgpath);
segDS = imageDatastore("augmentation/mask_fix");

%Augmentation
Inum = numel(imgDS.Files);

for i = 1 : Inum

    mask = im2gray(imread(string(segDS.Files(i))));
    mask(mask < 20) = 0;
    mask(mask > 0) = 255;


    CC = bwconncomp(mask);
    L = labelmatrix(CC);
    numObjects = max(L(:));

    [idx] = find(L > 0);
    augmentedData_white = imread(string(imgDS.Files(i)));

    augmentedData_whitered = augmentedData_white(:,:,1);
        augmentedData_whitegreen = augmentedData_white(:,:,2);
        augmentedData_whiteblue = augmentedData_white(:,:,3);


        idxx = ((augmentedData_whitered > 220) & (augmentedData_whitegreen > 220) & (augmentedData_whiteblue > 220));
        if (isempty(find(idxx > 0, 1)))
            redmean = 200;
            greenmean = 200;
            bluemean = 200;
        else
            redmean = mean(augmentedData_whitered(idxx), "all");
            greenmean = mean(augmentedData_whitegreen(idxx), "all");
            bluemean = mean(augmentedData_whiteblue(idxx), "all");
        end
        
        

        augmentedData_whitered(idx) = redmean;
        augmentedData_whitegreen(idx) = greenmean;
        augmentedData_whiteblue(idx) = bluemean;


        augmentedData_white(:,:,1) = augmentedData_whitered(:,:);
        augmentedData_white(:,:,2) = augmentedData_whitegreen(:,:);
        augmentedData_white(:,:,3) = augmentedData_whiteblue(:,:);

%     imshow(augmentedData_white);


    [~, name, ~] = fileparts(imgDS.Files(i));
%     imwrite(augmentedData{k}, 'augmentation/images/' + append(name, '_', string(m), '.jpg'), 'jp2', 'Mode', 'lossless');
    imwrite(augmentedData_white, "augmentation/images/" + append(name, 'w.jpg'), 'jp2', 'Mode', 'lossless');
%     imwrite(data{4}, 'augmentation/images/' + append('mask_', name, '_', string(i), 'w', '.jpg'), 'jp2', 'Mode', 'lossless');


end
