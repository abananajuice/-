function img_filtered=kalman(img_raw)
%kalman.m
%��ͼ����п������˲�ȥ��
%input:
%ԭʼͼ��ľ���
%output��
%�������˲���ľ���

[r1,c1] = size(img_raw);

%% �������
P=3;                         %����������Э�����ʼֵ
Q=20;                   %���̰���������
R=5;                    %���̰���Э����
A=1;                         %ϵͳ����
H=1;                         %�۲����

%% �˲�
X= img_raw(1,:,:);                                          %��ȡ����ͼ���һ��
img_filtered = zeros(r1,c1);
img_filtered(1,:,:)=X;
for K=2:r1
    X=A*X;              %�����k+1�У���ʼk+1=2
    P=A*P*A'+Q;      %����������Э����
    Kg=P*H'*inv(H*P*H'+R);  %kalman����
    X=X+Kg*(img_raw(K-1,:,:)-H*X);       %״̬���Ź���
    P=(1-Kg*H)*P;                         %Э�������Ź���
    img_filtered(K,:)=im2bw(X);
end


