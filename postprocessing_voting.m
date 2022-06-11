clear;close all;

var = 8;
Tnum = 315;


DSimg = cell(var,1);
DSlabelpath = cell(var,1);
DStxtfilepath = cell(var,1);

mapweight = cell(var, Tnum);

for k = 1 : var

    DSimg{k} = imageDatastore("yolov5/runs/detect/exp" + append(string(k)));
    DSlabelpath{k} = "yolov5/runs/detect/exp" + append(string(k), "/labels");
    DStxtfilepath{k} = dir(DSlabelpath{k} + "/*.txt");

end


% ==============================================================================================================
fprintf('add empty files\n')
for vari = 1 : var

    for i = 1 : numel(DSimg{vari}.Files)
    
        [~, imgname, ~] = fileparts(DSimg{vari}.Files{i});
        [~, txtname, ~] = fileparts(DStxtfilepath{vari}(i).name);
        
        if string(txtname) ~= string(imgname)

            tempID = fopen(DSlabelpath{vari} + append('/', imgname, '.txt'), 'w');
            fclose(tempID);

            DStxtfilepath{vari} = dir(DSlabelpath{vari} + "/*.txt");

        end
    
    end

end
fprintf('finish\n')
% ==============================================================================================================
fprintf('mean per var bbox\n')
for vari = 1 : var

    mkdir("yolov5/runs/detect/exp" + append(string(vari), "/weight0"));
    for Tnumi = 1 : Tnum

        [~, imgname, ~] = fileparts(DSimg{vari}.Files{((Tnumi - 1) * 10) + 1});
        mapweight{vari, Tnumi} = zeros(942, 1716);
        mapoutput = zeros(942, 1716);

        for i = 1 : 10 %每十張

            
            fileID = fopen(DSlabelpath{vari} + append('/', DStxtfilepath{vari}(((Tnumi - 1) * 10) + i).name) ,'r');
            data = fscanf(fileID,'%f');
            amount = length(data)/6;
        
            for j = 1 : amount %每一張
        
        
                if data(1 + (j - 1) * 6) ~= 0
                       fprintf('error');
        %                fprintf('%d,%d\n',i,data(1 + (j - 1) * 6))
                end
                centerx = data(2 + (j - 1) * 6);
                centery = data(3 + (j - 1) * 6);
                w = data(4 + (j - 1) * 6);
                h = data(5 + (j - 1) * 6);
                conf = data(6 + (j - 1) * 6);
                LUx = round(1716 * (centerx - w/2));
                LUy = round(942 * (centery - h/2));
                RDx = round(1716 * (centerx + w/2));
                RDy = round(942 * (centery + h/2));
                
                if LUx == 0
                    LUx = 1;
                end
                if LUy == 0
                    LUy = 1;
                end
                mapweight{vari, Tnumi}(LUy:RDy, LUx:RDx) = mapweight{vari, Tnumi}(LUy:RDy, LUx:RDx) + conf/10;

            end

            fclose(fileID);
        end

        mapweight{vari, Tnumi}(mapweight{vari, Tnumi} < 0.2) = 0;
        mapoutput(mapweight > 0) = 1;
%         figure
%         imshow(mapoutput);
        imwrite(mapweight{vari, Tnumi}, ("yolov5/runs/detect/exp" + append(string(vari), '/weight0/weight0_', imgname, '.jpg')), 'jp2', 'Mode', 'lossless');
    end

end
fprintf('finish\n')
%==============================================================================================================
fprintf('mean var bbox\n')

mapweightsum = cell(1, Tnum);

mkdir("yolov5/runs/detect/results0");

for Tnumi = 1 : Tnum

    [~, imgname, ~] = fileparts(DSimg{vari}.Files{((Tnumi - 1) * 10) + 1});

    mapweightsum{1, Tnumi} = zeros(942, 1716);

    for vari = 1 : var
        mapweightsum{1, Tnumi} = mapweightsum{1, Tnumi}(:,:) + mapweight{vari, Tnumi}(:,:)/var;
    end

    imwrite(mapweightsum{1, Tnumi}, ("yolov5/runs/detect/results0/" + append(imgname, '.jpg')), 'jp2', 'Mode', 'lossless');
end

fprintf('finish\n')
%==============================================================================================================

