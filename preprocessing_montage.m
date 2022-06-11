oringinDS = imageDatastore("OBJ_Train_Datasets/Train_Images");
boxDS = imageDatastore("OBJ_Train_Datasets/Training_Image_Box");
segDS = imageDatastore("OBJ_Train_Datasets/Training_Image_Seg");
bothDS = imageDatastore("OBJ_Train_Datasets/Training_Image_Both");



Inum = numel(oringinDS.Files);

for i = 1 : Inum

    a = readimage(oringinDS, i);
    b = readimage(boxDS, i);
    c = readimage(segDS, i);
    d = readimage(bothDS, i);
    e = montage({a, b, c, d});

    Montage = get(e, 'CData');
    [~, name, ~] = fileparts(oringinDS.Files(i));
    imwrite(Montage, "Training_Images_Observe/" + append(name, '.jpg'), 'jp2', 'Mode', 'lossless')
    close all;
end