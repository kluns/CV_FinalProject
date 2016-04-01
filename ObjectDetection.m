clear all;
no_of_cluster = 4;
%there are four Kernel descriptor please change Kernel here
kernel_des = './model/dep_gradient_model'; mode = 1;
%kernel_des = './model/dep_lbp_model'; mode = 1;
%kernel_des = './model/rgb_gradient_model'; mode = 2; 

for i = 621:701
    string_id = ['00' int2str(i)];
    colorIm_name = [string_id '-color.png'];
    depthIm_name = [string_id '-depth.png'];
    cd SceneImage;
    [Imdepth,map] = imread(depthIm_name,'png');
    [Imcolor,map] = imread(colorIm_name,'png');
    cd ..
    [position] = SegmentationVer2(Imdepth,Imcolor);%,string_id);
    cd Kernel_Descriptor;
    for k =1:no_of_cluster 
        if(mode == 1)
            Imresult = imcrop(Imdepth,[position(k,1) position(k,2) position(k,4) position(k,3)]);
        end
        if(mode == 2)
            Imresult = imcrop(Imcolor,[position(k,1) position(k,2) position(k,4) position(k,3)]);
        end
        if(position(k,3)>10)
           name = 'temp.png';
           imwrite(Imresult,name);
           desname = ['./' name];
             labelObject = label(kernel_des,desname);
            switch labelObject
                case 1
                    text_str{k} = 'bowl';%['bowl',int2str(k)];
                case 2
                    text_str{k} = 'cap';%['box',int2str(k)];
                case 3
                    text_str{k} = 'box';%['can',int2str(k)];
                case 4
                    text_str{k} = 'mug';%['can',int2str(k)];
                case 5
                    text_str{k} = 'soda';%['can',int2str(k)];
                otherwise
                    text_str{k} = ['no object',int2str(k)];
            end

        else
            test_str{k} = 'object';   
        end
    end
    cd ..
    figure(1) 
    imshow(uint8(Imcolor));
    hold on
    for num = 1:no_of_cluster
        if(position(num,3)>10)
            text(position(num,1),position(num,2)-10,text_str{num},'FontSize',20,'Color','blue');
            rectangle('Position',[position(num,1) position(num,2) position(num,4) position(num,3)],'EdgeColor','y');
        end
    end
    pause;
end
