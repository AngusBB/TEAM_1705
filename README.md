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

### Usage
###### first train
	1. copy OBJ_Train_Datasets/Train_Images' images in data/images Folder
	2. run preprocessing_xml2txt.py(txt labels files should create in data/labels Folder)
	3. terminal: cd yolov5
		     python train.py --img 1716 --batch 8 --epoch 500 --data dataset.yaml --weights yolov5s6.pt
		     python detect.py --weights model/best1.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25
