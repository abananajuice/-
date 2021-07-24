function im=cut(srcImg)
% 图像分割
% input:输入原始RGB图片
% output：分割后的一组灰度图像
% srcImg=imread('008.jpg');
%% 一中心部分为阈值进行二值化处理

srcImg=rgb2gray(srcImg);

im_g=im2bw(srcImg);
binImg=1-DUCO_RemoveBackGround(srcImg,5,0);

[height, width]=size(binImg);

%% 水平投影分割
hValArry=zeros(1,height); %%统计每行黑素像素点个数   
hProjectionMat=ones(height,width);  %投影直方图
for row=1:height
    for col=1:width
        perPixelValue = binImg(row, col);
        if (perPixelValue == 0)
            hValArry(row)=hValArry(row)+1;
        end
    end
end
for i=1:height    %%水平投影直方图
    for j=1:hValArry(i)
        perPixelValue = 0;
        hProjectionMat(i,width - 1 - j)=perPixelValue;
    end
end
% figure,imshow(hProjectionMat);
% title('水平投影');
imwrite(hProjectionMat,'水平投影.jpg');

startIndex = 0;  %%分割初始坐标
endIndex = 0;    %%分割终止坐标
inBlock = 0;     %%是否遍历到字符区域内
hIndexArr=zeros(500,2); %%存放分割坐标(10个分割坐标最多九行)
k1=1;
for i = 1:height
    if((inBlock==0)&&(hValArry(i)> 0))  %%进入字符区域
        inBlock = 1;
        startIndex = i;
    elseif ((hValArry(i) == 0) && (inBlock==1)) %进入空白区
        endIndex = i;
        inBlock = 0;
        hIndexArr(k1,1)=startIndex;
        hIndexArr(k1,2)=endIndex + 1;
        k1=k1+1;
    end
end

hIndexArr(all(hIndexArr==0,2),:) = [];
a=size(hIndexArr);
%srcImg=srcImg(hIndexArr(1,1):hIndexArr(1,2) +1,:);

%% 垂直投影分割
for q = 1:a(1)
    srcImg_vertical=binImg(hIndexArr(q,1):hIndexArr(q,2) +1,:);
    vValArry=zeros(1,width); %%统计每列黑素像素点个数
    verticalProjectionMat=ones(height,width);
    for col=1:width
        for row=1:height
            perPixelValue = binImg(row, col);
            if (perPixelValue == 0)    %%白底黑字
                vValArry(col)=vValArry(col)+1;
            end
        end
    end
for i=1:width   %%垂直投影直方图
    for j=1:vValArry(i)
        perPixelValue = 0;
        verticalProjectionMat(height - 1 - j, i)=perPixelValue;
    end
end


imwrite(verticalProjectionMat,'垂直投影.jpg');


startIndex = 0;  %%分割初始坐标
endIndex = 0;    %%分割终止坐标
inBlock = 0;     %%是否遍历到字符区域内

IndexArr=zeros(500,2);  %%存放分割坐标
k1=1;




for i = 1:width
    if((inBlock==0)&&(vValArry(i)> 0))   %%进入字符区域
        inBlock = 1;
        startIndex = i;
    elseif ((vValArry(i) == 0) && (inBlock==1)) %进入空白区
        endIndex = i;
        inBlock = 0;
        IndexArr(k1,1)=startIndex;
        IndexArr(k1,2)=endIndex + 1;
     
        
        if endIndex-startIndex>0.01*width
            k1=k1+1;
        end
        
    end
   
   
end
IndexArr(all(IndexArr==0,2),:) = [];
   b=size(IndexArr);
end

   %% 输出分割后的图片
   k=1;
   im=cell(1,b(1)*a(1));
   for m=1:a(1)
       for n = 1:b(1)
           A = im_g(hIndexArr(m,1):hIndexArr(m,2), IndexArr(n,1): IndexArr(n,2));
           if all(A(:)==1) == 0
               im{k}=A;
                k=k+1;              
           end   
       end
   end
   %% 去掉cell中空的组
   im(cellfun(@isempty,im))=[];
 
  %% 膨胀处理
  len = size(im);
 se=strel('square',3);
   for i=1:len(2) 
       im{i}=imerode(im{i},se);      
   end
   
   %% 图像调整
  
  for i=1:len(2)
      A=im{i};
       [x, y] = find(A == 0);
       A = A(min(x):max(x),min(y):max(y));  
      rate = 64 / max(size(A));
      A = imresize(A,rate);
       [x, y] = size(A);
       if x ~= 64
            A = [ones(ceil((64-x)/2)-1,y);A;ones(floor((64-x)/2)+1,y)];
       end
     if y ~= 64
        A = [ones(64,ceil((64-y)/2)-1),A,ones(64,floor((64-y)/2)+1)];
     end
%        im{i}=A;
%        imwrite(im{i},strcat('add\\',datestr(now,30),num2str(i),'.jpg'));
  end
 

       