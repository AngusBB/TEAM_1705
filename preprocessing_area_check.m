labelpath = "augmentation/labels";
Txtfile = dir(labelpath + "/*.txt");
Tnum = length(Txtfile);

tt = 0;

for i = 1 : Tnum

    ansfileID = fopen("data/labels/" + append(string(Txtfile(i).name)), 'w');
    fileID = fopen(labelpath + append('/', string(Txtfile(i).name)) ,'r');
    data = fscanf(fileID,'%f');
    amount = length(data)/5;

    for j = 1 : amount


        centerx = data(2 + (j - 1) * 5);
        centery = data(3 + (j - 1) * 5);
        w = data(4 + (j - 1) * 5);
        h = data(5 + (j - 1) * 5);
        
        if (w * h * 1716 * 942) > 800          
            fprintf(ansfileID, '0 %1.10f %1.10f %1.10f %1.10f\n', centerx, centery, w, h);
        else
            tt = tt + 1;
            fprintf(string(Txtfile(i).name)+'\n');
        end

    end
    
    fclose(fileID);
    fclose(ansfileID);
end
fprintf('%d\n', tt)