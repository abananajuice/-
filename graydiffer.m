function[differ] = graydiffer(h,T)
%���ܣ�����һ��ͼ��ǰ���ͱ������ƽ���ҶȲ�
%���룺ֱ��ͼ����h,�ָ���ֵT
%��������ƽ���ҶȲ�
s1 = sum(h(1:T));
    s2 = sum(h(T:255));
    n1 = 1:T;
    n2 = T:255;
    u1 = double(n1)*h(1:T)' / s1; %�����ҶȾ�ֵ
    u2 = double(n2)*h(T:255)' / s2; %ǰ���ҶȾ�ֵ

    differ = uint8(u2-u1);
end
