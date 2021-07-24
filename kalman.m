function img_filtered=kalman(img_raw)
%kalman.m
%对图像进行卡尔曼滤波去噪
%input:
%原始图像的矩阵
%output：
%卡尔曼滤波后的矩阵

[r1,c1] = size(img_raw);

%% 定义参数
P=3;                         %先验误差估计协方差初始值
Q=20;                   %过程白噪声方差
R=5;                    %过程白噪协方差
A=1;                         %系统矩阵
H=1;                         %观测矩阵

%% 滤波
X= img_raw(1,:,:);                                          %读取加噪图像第一行
img_filtered = zeros(r1,c1);
img_filtered(1,:,:)=X;
for K=2:r1
    X=A*X;              %先验第k+1行，开始k+1=2
    P=A*P*A'+Q;      %先验误差估计协方差
    Kg=P*H'*inv(H*P*H'+R);  %kalman增益
    X=X+Kg*(img_raw(K-1,:,:)-H*X);       %状态最优估计
    P=(1-Kg*H)*P;                         %协方差最优估计
    img_filtered(K,:)=im2bw(X);
end


