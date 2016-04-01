- The programms in this Folder are implemented by Meng-Chieh Yang in November at Stony Brook University.

- The original kernel descriptors and its implementetion are originated from the authors listed below( please refer to ../kde_2.0 for details):
Liefeng Bo, Xiaofeng Ren and Dieter Fox, Kernel Descriptors for Visual Recognition, Advances in Neural Information Processing Systems (NIPS), Dec. 2010.
Liefeng Bo, Xiaofeng Ren and Dieter Fox, Depth Kernel Descriptors for Object Recognition, IEEE/RSJ International Conference on Intelligent Robots and Systems (IROS), Sep. 2011.



Desription:
For repository 'Kernel_Descriptor' contains files that train models
./kde contains help functions and parameters for kernel descriptors
./model stores the results of trainning model
./feature stores the results of features we extracted from dataset
./image stores part of dataset(5 catagories) and the test images we have segmented
-train*.m  : train the model from correspondence features.
-prediction.m : use for test corped images set.
-label.m : function for object detection labeling.
-train_combination_gradient.m : train the model of mixed-features of gradient
-prediction_combination_gradient.m : test the accuracy of mixed-features
-getImageFromKinect.m : use to get images from kinect without calibriation.


Instruction:
We have stored the trainning results that can directly use for prediction.
you can use 'prediction.m' to test images set.
If you want to see the results of other features
1. Change following codes in angle brackets to the features you intend:
load ./model/<dep_gradient>_model;
load ./kde/<gradkdes_dep>_params;
kdes_params.kdes = <gradkdes_dep_params>;
2. If the features is extracted from RGB images, uncomment the following statments wihcih are commented:
imdir = './image/CropIm/';
%imdir = './image/test-rgb/‘;
imsubdir = dir_bo(imdir);
subname='-depth.png';
%subname='.png';


If someone want to train a new model:
a. use the 'train_*.m':
1. Change following codes in angle brackets to the features you intend:
load('<gradkdes_dep>_params');
kdes_params.kdes = <gradkdes_dep>_params;
(optional)2. Change the some of following paths:
data_params.savedir = ['./feature/train_' '<dep_gradient>'];
save -v7.3 ./feature/<fea_dep_gradkdes> ...
load ./feature/<fea_dep_gradkdes>;
fea= load('./feature/<fea_dep_gradkdes>');



