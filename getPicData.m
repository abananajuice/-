function I = getPicData()
% getPicData.m
% 读取digital_pic目录下的所有图像
% output:
% I : 64 * 64 * 1000, 包含1000张64*64二值图像

I = zeros(64,64,1000);
k = 1;


for i=1:10
    %内层：读取同意数字的100张图
    for j=1:100
        %file = sprintf('data_new\\%d_%d.jpg',i-1,j);
        file = sprintf('data_pic\\%d_%d.jpg',i-1,j);
        f=imread(file);
        bw=im2bw(f);
        %gray=rgb2gray(f);
        %bw=im2bw(gray);
        I(:,:,k)=bw;
        %图像计数器
        k=k+1;
    end
end

