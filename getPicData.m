function I = getPicData()
% getPicData.m
% ��ȡdigital_picĿ¼�µ�����ͼ��
% output:
% I : 64 * 64 * 1000, ����1000��64*64��ֵͼ��

I = zeros(64,64,1000);
k = 1;


for i=1:10
    %�ڲ㣺��ȡͬ�����ֵ�100��ͼ
    for j=1:100
        %file = sprintf('data_new\\%d_%d.jpg',i-1,j);
        file = sprintf('data_pic\\%d_%d.jpg',i-1,j);
        f=imread(file);
        bw=im2bw(f);
        %gray=rgb2gray(f);
        %bw=im2bw(gray);
        I(:,:,k)=bw;
        %ͼ�������
        k=k+1;
    end
end

