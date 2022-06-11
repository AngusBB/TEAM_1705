import glob
from xml.etree import cElementTree as ElementTree

OBJ_data_root = "OBJ_Train_Datasets"

image_file_list = sorted(glob.glob(OBJ_data_root + "/Train_Images/*.jpg"))
print("Found image files:", len(image_file_list), "\tfirst image file =", image_file_list[0])

sample_name_list = [f.split("/")[-1].split(".")[0] for f in image_file_list]

for sample_id in range(0, len(image_file_list)):

    xml_file = f"{OBJ_data_root}/Train_Annotations/{sample_id:08d}.xml"
    tree = ElementTree.parse(xml_file)
    root = tree.getroot()

    size = root.find('size')
    image_w = int(size.find('width').text)
    image_h = int(size.find('height').text)

    path = f"data/labels/{sample_id:08d}.txt"
    ff = open(path, 'w')

    for obj in root.iter('object'):
        name = obj.find('name').text.upper()
        bbox_list = []
        if name == "STAS":
            anno = obj.find('bndbox')
            xmin = round(int(anno.find('xmin').text) / image_w, 10)
            ymin = round(int(anno.find('ymin').text) / image_h, 10)
            xmax = round(int(anno.find('xmax').text) / image_w, 10)
            ymax = round(int(anno.find('ymax').text) / image_h, 10)
            bbox_list = [str(5) + ' ' + str((xmax+xmin)/2) + ' ' + str((ymax+ymin)/2) + ' ' + str((xmax-xmin)) + ' ' + str((ymax-ymin)) + '\n']
        ff.writelines(bbox_list)

    ff.close()

