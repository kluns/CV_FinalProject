{\rtf1\ansi\ansicpg950\cocoartf1348\cocoasubrtf170
{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset136 STHeitiTC-Light;}
{\colortbl;\red255\green255\blue255;}
\paperw11900\paperh16840\margl1440\margr1440\vieww14080\viewh14400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 This read me file edited by Kevin Tsai in November 2015 at Stony Brook University
\f1 .
\f0 \
\
The files in our document are as following: \
SceneImage (store image in this document)\
ObjectDetection.m\
ObjectDetection_Corp.m\
depthToCloud.m\
SegmentationVer2.m\
\
1. Before running our code, please run following commend \
 (1). run('vlfeat-0.9.20/toolbox/vl_setup')\
 (2). mex -setup \
\
2. The main file is ObjectDetection.m\
\
we read image from SceneImage.\
Because the size of dataset is too big, we only take part of image for demo. \
In the file, we run 70 images and show the classification. \
\
3. default setting\
    We use depth gradient kernel as our default setting. \
    if you would like to change different kernel,\
    please go to ObjectDetection.m\
    There are three type of kernel you can choose on the top of program \
    \
\
4. The files in Kernel_Descriptor are programmed for our combined kernel implement.\
}