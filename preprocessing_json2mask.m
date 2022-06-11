addpath("/Applications/MATLAB_R2022a.app/toolbox/jsonlab-master")

close all;

filepath = "SEG_Train_Datasets/Train_Annotations";

for k = 1 : Inum

    img = imread(imdsTrain.Files{k, 1});
    [~, name, ~] = fileparts(imdsTrain.Files(k));
    jsonData = loadjson(filepath + append("/", name, ".json"));
    
    [~, shapes_amount] = size(jsonData.shapes);

    % figure
    % imshow(img);
    % figure
    back = uint8(ones(942, 1716));
    % imshow(back)
    % axis off;
    for i = 1 : shapes_amount
        if isstruct(jsonData.shapes)
            back = insertShape(back, "FilledPolygon", jsonData.shapes(i).points, "Color", "white", "Opacity", 1, "LineWidth", 1);
        else
            back = insertShape(back, "FilledPolygon", jsonData.shapes{i}.points, "Color", "white", "Opacity", 1, "LineWidth", 1);
        end

    %     pgon = polyshape(jsonData.shapes(i).points);
    %     hold on;
    %     fig = plot(pgon, "FaceColor", "white", "FaceAlpha", 1, "LineWidth", 1, "EdgeColor", "white", "EdgeAlpha", 1);
    end
    
    
    % img2 = frame2im(fig);
    % saveas(fig, "augmentation/mask/" + append(name, ".jpg"), 'jpg')
    % Mask = get(e, 'CData');
    imwrite(back, "augmentation/mask/" + append(name, ".jpg"), 'jp2', 'Mode', 'lossless')

end