# TEAM_1705

### Requirments
	MATLAB: 
		Image Processing Toolbox=11.5
		Computer Vision Toolbox=10.2
		Image Acquisition Toolbox=6.6
		Requirements Toolbox=2.0
		MATLAB Coder=5.4
		MATLAB Compiler=8.4
		jsonlab-master
    
	Python:
		matplotlib>=3.2.2
		NumPy>=1.18.5
	    	OpenCV-python>=4.1.1
	   	Pillow>=7.1.2
	    	PyYAML>=5.3.1
	    	requests>=2.23.0
	    	torch>=1.7.0
	    	torchvision>=0.8.1
	    	tqdm>=4.41.0

### Datasets
	download the public and private images in All_Detect_Images Folder
	download the OBJ_Train_Datasets in OBJ_Train_Datasets Folder
	download the SEG_Train_Datasets in SEG_Train_Datasets Folder
	download the Train_Images_Normal (https://drive.google.com/drive/folders/1ufKWQl4XOcjvkpYKQCH0BSMU2nmNd2st?usp=sharing) in Train_Images_Normal Folder
	download the binary masks (https://drive.google.com/drive/folders/1B2JP8a_fJszJOGK_m9beChNJZKCJ5B_9?usp=sharing) in augmentation/mask Folder
	download the model files (https://drive.google.com/drive/folders/1TEW5dOQFPtVOKYhCsoE_QDuEu5GFkoIJ?usp=sharing) in model Folder

### Usage
###### first train
	1. copy OBJ_Train_Datasets/Train_Images' images in data/images Folder
	2. run preprocessing_xml2txt.py(txt labels files should be created in data/labels Folder)
	3. terminal: cd yolov5
		     python train.py --img 1716 --batch 8 --epoch 500 --data dataset.yaml --weights yolov5s6.pt
		     python detect.py --weights model/best1.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25
	4. run postprocessing_txt2json.m(may need to change the labels path, and it'll create an answer.json)
	
###### second train
	1. run preprocessing_augmentation1.m(augmentation images should be created in augmentation/images)
	2. run preprocessing_area_check.m(delete the broken boundingbox)
	3. run preprocessing_jp2tojpg1.py(jp2 to jpg)
	3. terminal: cd yolov5
		     python -m torch.distributed.launch --nproc_per_node 4 train.py --weights yolov5l6.pt --cfg models/hub/yolov5l6.yaml --data dataset.yaml --epochs 500 --batch-size 40 --imgsz 1728 --device 0,1,2,3 --single-cls --sync-bn
		     python detect.py --weights model/best2.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25
	4. run postprocessing_txt2json.m(may need to change the labels path, and it'll create an answer.json)
