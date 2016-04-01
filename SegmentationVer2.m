function [Square] = SegmentationVer2(Imdepth,Imcolor)%,string_id)

% cd ..
no_of_cluster = 4;
fY = [-1 -2 -1; 0 0 0;1 2 1];
Gy = conv2(double(Imdepth),double(fY),'same');

%parameter 
%the number of cluster 
K = 4;
cluster0= Imcolor;

%depth to point cloud 
[pcloud, distance] = depthToCloud(Imdepth);
Zdepth(:,:) = pcloud(:,:,3);
Zdepth(isnan(Zdepth))=0;

%k-mean
ab = reshape(Zdepth,[1 480*640]);
[cluster_center,cluster_idx ] = vl_kmeans(ab,K);
pixel_labels = reshape(cluster_idx,[480 640]);

%first is zero so take second the most close 
for i = 1:4
    layerlabel(i) = mean2(Zdepth(find(pixel_labels==i)));
end

A = sort(layerlabel);
for i = 1:K
    if(layerlabel(i)==A(2))
        id_tabel = i;
    end
end

%remove the table 
count = 1;
for i=1:480
    for j = 1:640
        if(pixel_labels(i,j) ==id_tabel && Gy(i,j)<5 && i<400)
            cluster0(i,j,1) = Imcolor(i,j,1);
            cluster0(i,j,2) = Imcolor(i,j,2);
            cluster0(i,j,3) = Imcolor(i,j,3);
            cluster1(1,count) = i;
            cluster1(2,count) = j;
            count = count + 1;
        else 
            cluster0(i,j,:) = 0;
        end
    end
end

%reshape image and focus on the table
Imgray = rgb2gray(cluster0);
%imshow(uint8(cluster0));

[center,assignment] = vl_kmeans(cluster1,no_of_cluster);
 for i = 1:no_of_cluster
   square_len = floor(sqrt(size(find(assignment(1,:)==i),2)))+50;
   Square(i,1) = center(2,i)-floor(square_len/2);
   Square(i,2) = center(1,i)-floor(square_len/2);
   if(Square(i,1)==0 || Square(i,1)<0)
       Square(i,1) = 1;
   end
   if(Square(i,2)==0 || Square(i,2)<0)
       Square(i,2) = 1;
   end
   Square(i,3) = square_len;
   Square(i,4) = square_len;
   tempW = floor(Square(i,1))+floor(Square(i,3)/2);
   tempH = floor(Square(i,2))+floor(Square(i,3)/2);
   if(tempW>480)
       tempW = 480;
   end
   
   AA = Imdepth(floor(Square(i,1)):tempW,floor(Square(i,2)):tempH);
   average_depth(i) = sum(AA(:))/(size(AA,1)*size(AA,2));
 end

for i = 1:no_of_cluster-1
    for j = i+1:no_of_cluster
        center_dist = sqrt((Square(i,1)-Square(j,1))^2+(Square(i,2)-Square(j,2))^2);
        if(center_dist<Square(i,3) && Square(i,3) >2)%two rectangle overlap 
            diff_depth = abs(average_depth(i)-average_depth(j));
            if(diff_depth<1000 && Square(i,3)>2 && Square(j,3)>2); % merge two 
                if(Square(i,2)<Square(j,2))
                    Square(i,3) = 2*Square(i,3);
                    Square(j,3) = 1;
                    Square(j,4) = 1;
                else
                    Square(j,3) = 2*Square(j,3);
                    Square(i,3) = 1;
                    Square(i,4) = 1;
                end
            end
        end
    end
end

%figure(2)
%imshow(Imdepth);
%hold on
%cd CropIm;
%for i = 1:no_of_cluster
    %if(Square(i,3)>10)
%         Imresult = imcrop(Imcolor,[Square(i,1) Square(i,2) Square(i,4) Square(i,3)]);
%         name = [string_id int2str(i)];
%         name = [name '-depth'];
%         name = [name '.png'];
%         imwrite(Imresult,name);
    
        %     figure(i) 
        %     imshow(cluster0);
        %     hold on
        %     rectangle('Position',[Square(i,1) Square(i,2) Square(i,4) Square(i,3)],'EdgeColor','y');

    %end
%end
%cd ..
end