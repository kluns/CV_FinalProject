clear all;

%load the model & parameter
load ./model/dep_gradient_model;
load ./kde/gradkdes_dep_params;
kdes_params.kdes = gradkdes_dep_params;
data_params.savedir = ['./feature/test_' 'dep_gradient'];

% add paths
addpath('../kdes_2.0/liblinear-1.5-dense-float/matlab');
addpath('../kdes_2.0/helpfun');
addpath('../kdes_2.0/kdes');
addpath('../kdes_2.0/emk');

% initialize the parameters of kdes
kdes_params.grid = 8;   % kdes is extracted every 8 pixels
kdes_params.patchsize = 16;  % patch size


% compute the paths of images
imdir = './image/CropIm/';
% imdir = './image/test-rgb/';
imsubdir = dir_bo(imdir);
subname='-depth.png';
% subname='.png';
impath = [];

it=1;
for i = 1:length(imsubdir)
    datapath{i} = dir([imdir imsubdir(i).name '/*' subname ]);
    size=length(datapath{i});
    sub=datapath{i};
    for k=1:size
        it=it+1;
        impath{1,it}=[imdir imsubdir(i).name '/' sub(k).name];
    end
end
impath=impath(~cellfun('isempty',impath));


% initialize the parameters of data
data_params.datapath = impath;
data_params.tag = 1;
data_params.minsize = 45;  % minimum size of image
data_params.maxsize = 300; % maximum size of image

% extract kernel descriptors of test image
mkdir_bo(data_params.savedir);
gen_kdes_batch(data_params, kdes_params);
rgbdkdespath_tmp = get_kdes_path(data_params.savedir);
rgbdkdespath = rgbdkdespath_tmp;

% constrained kernel SVD coding
disp('Extract image features ... ...');

% initialize the params of emk
emk_params.pyramid = [1 2 4];
emk_params.ktype = 'rbf';
emk_params.kparam = 0.001;
fea_params.feapath = rgbdkdespath;
rgbdfea = cksvd_emk_batch(fea_params, trainobj.basis_params, emk_params);
rgbdfea = single(rgbdfea);

% give labels to test images
testlabel=[ones(1,48) ones(1,50).*3 ones(1,38).*5];

% feed it to model
testhmp = rgbdfea;
testhmp = scaletest(testhmp, 'power', trainobj.minvalue, trainobj.maxvalue);
[predictlabel, accuracy, decvalues] = predict(double(testlabel'),sparse(double(testhmp')), trainobj.model);
