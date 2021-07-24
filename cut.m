function im=cut(srcImg)
% ͼ��ָ�
% input:����ԭʼRGBͼƬ
% output���ָ���һ��Ҷ�ͼ��
% srcImg=imread('008.jpg');
%% һ���Ĳ���Ϊ��ֵ���ж�ֵ������

srcImg=rgb2gray(srcImg);

im_g=im2bw(srcImg);
binImg=1-DUCO_RemoveBackGround(srcImg,5,0);

[height, width]=size(binImg);

%% ˮƽͶӰ�ָ�
hValArry=zeros(1,height); %%ͳ��ÿ�к������ص����   
hProjectionMat=ones(height,width);  %ͶӰֱ��ͼ
for row=1:height
    for col=1:width
        perPixelValue = binImg(row, col);
        if (perPixelValue == 0)
            hValArry(row)=hValArry(row)+1;
        end
    end
end
for i=1:height    %%ˮƽͶӰֱ��ͼ
    for j=1:hValArry(i)
        perPixelValue = 0;
        hProjectionMat(i,width - 1 - j)=perPixelValue;
    end
end
% figure,imshow(hProjectionMat);
% title('ˮƽͶӰ');
imwrite(hProjectionMat,'ˮƽͶӰ.jpg');

startIndex = 0;  %%�ָ��ʼ����
endIndex = 0;    %%�ָ���ֹ����
inBlock = 0;     %%�Ƿ�������ַ�������
hIndexArr=zeros(500,2); %%��ŷָ�����(10���ָ�����������)
k1=1;
for i = 1:height
    if((inBlock==0)&&(hValArry(i)> 0))  %%�����ַ�����
        inBlock = 1;
        startIndex = i;
    elseif ((hValArry(i) == 0) && (inBlock==1)) %����հ���
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

%% ��ֱͶӰ�ָ�
for q = 1:a(1)
    srcImg_vertical=binImg(hIndexArr(q,1):hIndexArr(q,2) +1,:);
    vValArry=zeros(1,width); %%ͳ��ÿ�к������ص����
    verticalProjectionMat=ones(height,width);
    for col=1:width
        for row=1:height
            perPixelValue = binImg(row, col);
            if (perPixelValue == 0)    %%�׵׺���
                vValArry(col)=vValArry(col)+1;
            end
        end
    end
for i=1:width   %%��ֱͶӰֱ��ͼ
    for j=1:vValArry(i)
        perPixelValue = 0;
        verticalProjectionMat(height - 1 - j, i)=perPixelValue;
    end
end


imwrite(verticalProjectionMat,'��ֱͶӰ.jpg');


startIndex = 0;  %%�ָ��ʼ����
endIndex = 0;    %%�ָ���ֹ����
inBlock = 0;     %%�Ƿ�������ַ�������

IndexArr=zeros(500,2);  %%��ŷָ�����
k1=1;




for i = 1:width
    if((inBlock==0)&&(vValArry(i)> 0))   %%�����ַ�����
        inBlock = 1;
        startIndex = i;
    elseif ((vValArry(i) == 0) && (inBlock==1)) %����հ���
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

   %% ����ָ���ͼƬ
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
   %% ȥ��cell�пյ���
   im(cellfun(@isempty,im))=[];
 
  %% ���ʹ���
  len = size(im);
 se=strel('square',3);
   for i=1:len(2) 
       im{i}=imerode(im{i},se);      
   end
   
   %% ͼ�����
  
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
 

       