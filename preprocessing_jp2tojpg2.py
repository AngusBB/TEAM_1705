import cv2
import glob

image_file_list = sorted(glob.glob("augmentation/Detect_Image_Aug/*.jpg"))
print("Found image files:", len(image_file_list), "\tfirst image file =", image_file_list[0])

image_name_list = [f.split("/")[-1].split(".")[0] for f in image_file_list]

for i in range(0, len(image_file_list)):
    image = cv2.imread(image_file_list[i])
    cv2.imshow('', image)
    cv2.imwrite('All_Detect_Images/' + image_name_list[i] + '.jpg', image, [int(cv2.IMWRITE_JPEG_QUALITY), 100])
