function predictlabel = label(job,source_address)

% add paths
addpath('../kdes_2.0/liblinear-1.5-dense-float/matlab');
addpath('../kdes_2.0/helpfun');
addpath('../kdes_2.0/kdes');
addpath('../kdes_2.0/emk');


% extract feature of source
% step1: initialize the parameters of kdes
kdes_params.grid = 8;   % kdes is extracted every 8 pixels
kdes_params.patchsize = 16;  % patch size
load('./kde/gradkdes_dep_params');
load(job);
%load('./model/dep_gradient_model');
kdes_params.kdes = gradkdes_dep_params;


% step2: initialize the parameters of data
data_params.datapath{1} = source_address;
data_params.tag = 1;
data_params.minsize = 45;  % minimum size of image
data_params.maxsize = 300; % maximum size of image
data_params.savedir = ['./feature/test_' 'dep_gradient'];

% step3: extract kernel descriptors
mkdir_bo(data_params.savedir);

gen_kdes_batch(data_params, kdes_params);
rgbdkdespath_tmp = get_kdes_path(data_params.savedir);
rgbdkdespath{1} = rgbdkdespath_tmp{1};

% step4: constrained kernel SVD coding
disp('Extract image features ... ...');
% step5: initialize the params of emk
emk_params.pyramid = [1 2 4];
emk_params.ktype = 'rbf';
emk_params.kparam = 0.001;
fea_params.feapath = rgbdkdespath;
rgbdfea = cksvd_emk_batch(fea_params, trainobj.basis_params, emk_params);
rgbdfea = single(rgbdfea);
testlabel=[1];

% feed it to model
testhmp = rgbdfea;
testhmp = scaletest(testhmp, 'power', trainobj.minvalue, trainobj.maxvalue);
[predictlabel, accuracy, decvalues] = predict(double(testlabel'),sparse(double(testhmp')), trainobj.model);


end