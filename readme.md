This read me file edited by Kevin Tsai and Jay Yang in November 2015 at Stony Brook University.

The files in our document are as following:
SceneImage (store image in this document)
ObjectDetection.m\
ObjectDetection_Corp.m\
depthToCloud.m\
SegmentationVer2.m\

1. Before running our code, please run following commend:
 (1). run('vlfeat-0.9.20/toolbox/vl_setup')
 (2). mex -setup

2. The main file is ObjectDetection.m
we read image from SceneImage.
Because the size of dataset is too big, we only take part of image for demo.
In the file, we run 70 images and show the classification.

3. default setting
We use depth gradient kernel as our default setting.  If you would like to change different kernel, please go to ObjectDetection.m.  There are three type of kernel you can choose on the top of program.

4. The files in Kernel_Descriptor are programmed for our combined kernel implement.