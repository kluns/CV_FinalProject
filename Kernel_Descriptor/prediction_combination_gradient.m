clear all; close all; clc;

% add paths
addpath('../kdes_2.0/liblinear-1.5-dense-float/matlab');
addpath('../kdes_2.0/helpfun');
addpath('../kdes_2.0/kdes');
addpath('../kdes_2.0/emk');

path_dep=load('./kde/path_test_dep');
path_rgb=load('./kde/path_test_rgb');

load ./model/combination_gradient_model;

rgbdkdespath=[];
for i=1:length(path_dep.rgbdkdespath)
    d=load(path_dep.rgbdkdespath{i});
    r=load(path_rgb.rgbdkdespath{i});
    arr_d=d.feaSet.feaArr{1};
    arr_r=r.feaSet.feaArr{1};
    arr=[];
    for j=1:numel(arr_d)/200
        tem=[arr_d(:,j);arr_r(:,j)];
        arr=[arr tem];
    end
    feaSet=d.feaSet;
    feaSet.feaArr{1}=arr;
    save(['./feature/test_combination_gradient/' sprintf('%06d',i)], 'feaSet');
    path{1,i}=['./feature/test_combination_gradient/' sprintf('%06d',i)];
end

rgbdkdespath=path;
rgbdkdespath=rgbdkdespath(~cellfun('isempty',rgbdkdespath));

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
