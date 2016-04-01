% combine pure features to a experimental mixed-features and 
% train the model

clear all; close all; clc;

% add paths
addpath('../kdes_2.0/liblinear-1.5-dense-float/matlab');
addpath('../kdes_2.0/helpfun');
addpath('../kdes_2.0/kdes');
addpath('../kdes_2.0/emk');


% This part is for create a mixed-feature
% In our project, we have tried the sum of gradients from RGB images and from depth
% images as a different way in implementing property of hierarchy.
% becuase of the time, we fail to try another hierarchial way of feature
% descriptors

% path_dep=load('./kde/path_dep');
% path_rgb=load('./kde/path_rgb');
% rgbdkdespath=[];
% 
% for i=3500:length(path_dep.rgbdkdespath)
%     d=load(path_dep.rgbdkdespath{i});
%     r=load(path_rgb.rgbdkdespath{i});
%     arr_d=d.feaSet.feaArr{1};
%     arr_r=r.feaSet.feaArr{1};
%     arr=[];
%     for j=1:size(arr_d,2)
%         tem=[arr_d(:,j);arr_r(:,j)];
%         arr=[arr tem];
%     end
%     feaSet=d.feaSet;
%     feaSet.feaArr{1}=arr;
%     save(['./feature/train_combination_gradient/' sprintf('%06d',i)], 'feaSet');
%     path{1,i}=['./feature/train_combination_gradient/' sprintf('%06d',i)];
%     tem_l(i)=rgbdclabel(i);
%     disp(i);
% end

% rgbdkdespath=path;
% label=tem_l;
% rgbdkdespath=rgbdkdespath(~cellfun('isempty',rgbdkdespath));
% label(label==0)=[];


% if want to change a new set of visual words and extract new emk features
% change the value of featag to 1
featag = 0;

if featag

    %  initialize the parameters of basis vectors
    basis_params.samplenum = 10; % maximum sample number per image scale
    basis_params.wordnum = 1000; % number of visual words
    fea_params.feapath = rgbdkdespath;
    %   learn visual words using K-means
    rgbdwords = visualwords(fea_params, basis_params);
    basis_params.basis = rgbdwords;
    
    %  constrained kernel SVD coding
    disp('Extract image features ... ...');
    %  initialize the params of emk
    emk_params.pyramid = [1 2 4];
   emk_params.ktype = 'rbf';
   emk_params.kparam = 0.001;
   fea_params.feapath = rgbdkdespath;
   rgbdfea = cksvd_emk_batch(fea_params, basis_params, emk_params);
   rgbdfea = single(rgbdfea);
   save -v7.3 ./feature/fea_combination_gradkdes rgbdfea label basis_params;
else
   load ./feature/fea_combination_gradkdes;
end

fea= load('./feature/fea_combination_gradkdes');

% train the model
trainhmp = fea.rgbdfea;
[trainhmp, minvalue, maxvalue] = scaletrain(trainhmp, 'power');
trainlabel = fea.label; % take category label
lc = 10;
option = ['-s 1 -c ' num2str(lc)];

model = train(double(trainlabel'),sparse(double(trainhmp')),option);
trainobj.model=model;
trainobj.minvalue=minvalue;
trainobj.maxvalue=maxvalue;
trainobj.basis_params=basis_params;

save -v7.3  ./model/combination_gradient_model trainobj;

