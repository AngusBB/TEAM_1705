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
		     (to train your own model)python train.py --img 1716 --batch 8 --epoch 500 --data dataset.yaml --weights yolov5s6.pt
		     python detect.py --weights model/best1.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25
	4. run postprocessing_txt2json.m(may need to change the labels path, and it'll create an answer.json)
	
###### second train
	1. run preprocessing_augmentation1.m(augmentation images should be created in augmentation/images, augmentation labels should be created in data/labels)
	2. run preprocessing_area_check.m(delete the broken boundingbox)
	4. run preprocessing_jp2tojpg1.py(the image should be transfered to data/images)
	5. terminal: cd yolov5
		     (to train your own model)python -m torch.distributed.launch --nproc_per_node 4 train.py --weights yolov5l6.pt --cfg models/hub/yolov5l6.yaml --data dataset.yaml --epochs 500 --batch-size 40 --imgsz 1728 --device 0,1,2,3 --single-cls --sync-bn
		     python detect.py --weights model/best2.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25
	6. run postprocessing_txt2json.m(may need to change the labels path, and it'll create an answer.json)

###### third train
	1. clean all the images and labels in data Folder
	2. copy OBJ_Train_Datasets/Train_Images' images in data/images Folder
	3. run preprocessing_xml2txt.py(txt labels files should be created in data/labels Folder)
	4. run preprocessing_augmentation2.m(augmentation images should be created in augmentation/images, augmentation labels should be created in data/labels)
	5. run preprocessing_area_check.m(delete the broken boundingbox)
	6. run preprocessing_augmentation_train_mask.m(augmentation images should be created in augmentation/images)
	7. run preprocessing_augmentation_normal_tissue.m(augmentation images should be created in augmentation/images)
	8. run preprocessing_jp2tojpg1.py(the image should be transfered to data/images)
	9. terminal: cd yolov5
		     (to train your own model)python -m torch.distributed.launch --nproc_per_node 8 train.py --weights yolov5x6.pt --cfg models/hub/yolov5x6.yaml --data dataset.yaml --epochs 250 --batch-size 40 --imgsz 1728 --device 0,1,2,3,4,5,6,7 --single-cls --optimizer SGD --sync-bn
		     (to train your own model)python -m torch.distributed.launch --nproc_per_node 8 train.py --weights yolov5l6.pt --cfg models/hub/yolov5l6.yaml --data dataset.yaml --epochs 250 --batch-size 64 --imgsz 1728 --device 0,1,2,3,4,5,6,7 --single-cls --optimizer AdamW --cos-lr --sync-bn
		     (to train your own model)python -m torch.distributed.launch --nproc_per_node 8 train.py --weights yolov5x6.pt --cfg models/hub/yolov5x6.yaml --data dataset.yaml --epochs 250 --batch-size 40 --imgsz 1728 --device 0,1,2,3,4,5,6,7 --single-cls --optimizer AdamW --cos-lr --sync-bn
		     (to train your own model)python -m torch.distributed.launch --nproc_per_node 8 train.py --weights yolov5l6.pt --cfg models/hub/yolov5l6.yaml --hyp data/hyps/hyp.scratch-med.yaml --data dataset.yaml --epochs 250 --batch-size 64 --imgsz 1728 --device 0,1,2,3,4,5,6,7 --single-cls --optimizer AdamW --cos-lr --sync-bn
	10. run postprocessing_augmentation_detect.m
	11. run preprocessing_jp2tojpg2.py(the image should be transfered to All_Detect_Images)
	12. terminal: cd yolov5
		     python detect.py --weights model/best3-1.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-1.pt --img 2240,4032 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-2.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-2.pt --img 2240,4032 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-3.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-3.pt --img 2240,4032 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-4.pt --img 960,1720 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
		     python detect.py --weights model/best3-4.pt --img 2240,4032 --conf_thres 0.05 --max-det 200 --augment --iou_thres 0.25 --source All_Detect_Images --data dataset.yaml --agnostic-nms --save-conf
	13. run postprocessing_voting.m(the voting results will be create in yolov5/runs/detect/results0, and the values of confident can be export from the variable mapweightsum)

thanks to ultralytics making wonderful yolov5 project
