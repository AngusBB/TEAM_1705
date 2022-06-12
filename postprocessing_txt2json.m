labelpath = "runs/detect/exp1";
Txtfile = dir(labelpath + "/*.txt");
Tnum = length(Txtfile);

ansfileID = fopen("answer.json", 'w');

fprintf(ansfileID, '{');

for i = 1 : Tnum
    [~, txtname, ~] = fileparts(Txtfile(i).name);
%     fprintf(txtname)
    fprintf(ansfileID, append('"', txtname, '.jpg', '":['));


    fileID = fopen(labelpath + append('/', string(Txtfile(i).name)) ,'r');
    data = fscanf(fileID,'%f');
    amount = length(data)/6;

    for j = 1 : amount


        if data(1 + (j - 1) * 6) ~= 0
               fprintf('error');
               fprintf('%d,%d\n',i,data(1 + (j - 1) * 6))
        end
        centerx = data(2 + (j - 1) * 6);
        centery = data(3 + (j - 1) * 6);
        w = data(4 + (j - 1) * 6);
        h = data(5 + (j - 1) * 6);
        conf = data(6 + (j - 1) * 6);
%         STAS = [round(1716 * (centerx - w/2)), round(942 * (centery - h/2)), round(1716 * (centerx + w/2)), round(942 * (centery + h/2)), roundn(conf, -5)];
        fprintf(ansfileID, '[%d, %d, %d, %d, %1.5f]', floor(1716 * (centerx - w/2)), floor(942 * (centery - h/2)), ceil(1716 * (centerx + w/2)), ceil(942 * (centery + h/2)), roundn(conf, -5));
        if j ~= amount
            fprintf(ansfileID, ', ');
        end
    end
    


    fclose(fileID);
    fprintf(ansfileID, ']');
    if i ~= Tnum
        fprintf(ansfileID, ', ');
    end
%     fprintf(ansfileID, '\n');

end

fprintf(ansfileID, '}');
fclose(ansfileID);
