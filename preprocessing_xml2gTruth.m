ds = fileDatastore('OBJ_Train_Datasets/Train_Annotations','ReadFcn',@readFcn);
T_bbox= readall(ds);
ds2 = fileDatastore('OBJ_Train_Datasets/Train_Annotations','ReadFcn',@readFcn2);
T_file= readall(ds2);

gTruth_labeler = table(T_file,T_bbox);

%==========================================================================
function  [bboxList,objectFile] = readFcn(x)

xmltxt = readstruct(x);
objectPos = xmltxt.object;
text = [objectPos.bndbox];

outputlist = reshape(struct2array(text),[],size(text,2))';
W = abs(outputlist(:,3) - outputlist(:,1));
H = abs(outputlist(:,4) - outputlist(:,2));
xmin = outputlist(:,1);
ymin = outputlist(:,2);
bboxList = [xmin,ymin,W,H];
objectFile = xmltxt.filename;

end
%==========================================================================
function  objectFile = readFcn2(x)

xmltxt = readstruct(x);
objectFile = xmltxt.filename;

end
%==========================================================================