
% modified by Meng-Chieh Yang
% source code from Liefeng Bo from http://www.cs.washington.edu/robotics/projects/kdes/


% modified by Meng-Chieh Yang at SBU
% originated  on 03/27/2012 in University of Washington

clear;

% add paths
addpath('../kdes_2.0/liblinear-1.5-dense-float/matlab');
addpath('../kdes_2.0/helpfun');
addpath('../kdes_2.0/kdes');
addpath('../kdes_2.0/emk');

% compute the paths of images
imdir = './image/rgbd-dataset/';
imsubdir = dir_bo(imdir);
impath = [];
rgbdclabel = [];
rgbdilabel = [];
rgbdvlabel = [];
subsample = 1;
label_num = 0;
for i = 1:length(imsubdir)
    [rgbdilabel_tmp, impath_tmp] = get_im_label([imdir imsubdir(i).name '/'], '_crop.png');
    for j = 1:length(impath_tmp)
        ind = find(impath_tmp{j} == '_');
        rgbdvlabel_tmp(1,j) = str2num(impath_tmp{j}(ind(end-2)+1));
    end

    it = 0;
    for j = 1:subsample:length(impath_tmp)
        it = it + 1;
        impath_tmp_sub{it} = impath_tmp{j};
    end
    impath = [impath impath_tmp_sub];
    rgbdclabel = [rgbdclabel i*ones(1,length(impath_tmp_sub))];
    rgbdilabel = [rgbdilabel rgbdilabel_tmp(1:subsample:end)+label_num];
    rgbdvlabel = [rgbdvlabel rgbdvlabel_tmp(1:subsample:end)];
    label_num = label_num + length(unique(rgbdilabel_tmp));
    clear impath_tmp_sub rgbdvlabel_tmp;
end

% initialize the parameters of kdes
load('gradkdes_params');
kdes_params.kdes = gradkdes_params;

kdes_params.grid = 8;   % kdes is extracted every 8 pixels
kdes_params.patchsize = 16;  % patch size

% initialize the parameters of data
data_params.savedir = ['./feature/train_' 'rgb_gradient'];
data_params.datapath = impath;
data_params.tag = 1;
data_params.minsize = 45;  % minimum size of image
data_params.maxsize = 300; % maximum size of image

% extract kernel descriptors
mkdir_bo(data_params.savedir);
rgbdkdespath = get_kdes_path(data_params.savedir);
if length(rgbdkdespath) ~= size(impath,2)
   gen_kdes_batch(data_params, kdes_params);
   rgbdkdespath = get_kdes_path(data_params.savedir);
end

featag = 1;
if featag
   % learn visual words using K-means
   % initialize the parameters of basis vectors
   basis_params.samplenum = 10; % maximum sample number per image scale
   basis_params.wordnum = 1000; % number of visual words
   fea_params.feapath = rgbdkdespath;
   rgbdwords = visualwords(fea_params, basis_params);
   basis_params.basis = rgbdwords;
   
   % constrained kernel SVD coding
   disp('Extract image features ... ...');
   % initialize the params of emk
   emk_params.pyramid = [1 2 4];
   emk_params.ktype = 'rbf';
   emk_params.kparam = 0.001;
   fea_params.feapath = rgbdkdespath;
   rgbdfea = cksvd_emk_batch(fea_params, basis_params, emk_params);
   rgbdfea = single(rgbdfea);
   save -v7.3 ./feature/fea_rgb_gradkdes rgbdfea rgbdclabel rgbdilabel basis_params;
else
   load ./feature/fea_rgb_gradkdes;
end

fea= load('./feature/fea_rgb_gradkdes');

% train the model
trainhmp = fea.rgbdfea;
[trainhmp, minvalue, maxvalue] = scaletrain(trainhmp, 'power');
trainlabel = fea.rgbdclabel; % take category label
lc = 10;
option = ['-s 1 -c ' num2str(lc)];

model = train(double(trainlabel'),sparse(double(trainhmp')),option);
trainobj.model=model;
trainobj.minvalue=minvalue;
trainobj.maxvalue=maxvalue;
trainobj.basis_params=basis_params;

save -v7.3  ./model/rgb_gradient_model trainobj;
