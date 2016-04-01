clc; clear all; close all;

addpath('/Users/MENGJAY/Documents/MATLAB/OpenNI1/Mex')
SAMPLE_XML_PATH='/Users/MENGJAY/Documents/MATLAB/OpenNI1/Config/SamplesConfig.xml';


KinectHandles = mxNiCreateContext(SAMPLE_XML_PATH);
mxNiChangeDepthViewPoint(KinectHandles);
I=mxNiPhoto(KinectHandles); I=permute(I,[3 2 1]);
D=mxNiDepth(KinectHandles); D=permute(D,[2 1]);
% D=mxNiDepthRealWorld(KinectHandles);

figure(1);
subplot(1,2,1),h1=imshow(I); 
subplot(1,2,2),h2=imshow(D,[0 3000]); colormap('jet');
close;

SourceImage=I;
DepthImage=D;

save('image3.mat', 'SourceImage','DepthImage','-append') ;
S=load('image3.mat');
D=S.DepthImage;
I=S.SourceImage;

figure(1);
imshow(D,[0 5000]);
figure(2);
imshow(I);




for i=1:480
    for j=1:640
        if D(i,j)>=2000 || D(i,j)<=0
            D1(i,j)=0;
        else
            D1(i,j)=255;
        end
    end
end

for i=1:480
    for j=1:640
        if D1(i,j)==255
            D2(i,j)=I(i,j);
        else
            D2(i,j)=D1(i,j);
        end 
    end
end


figure(2);
imshow(uint8(D2));

mxNiDeleteContext(KinectHandles);
