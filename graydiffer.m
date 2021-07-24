function[differ] = graydiffer(h,T)
%功能：计算一幅图像前景和背景类间平均灰度差
%输入：直方图数据h,分割阈值T
%输出：类间平均灰度差
s1 = sum(h(1:T));
    s2 = sum(h(T:255));
    n1 = 1:T;
    n2 = T:255;
    u1 = double(n1)*h(1:T)' / s1; %背景灰度均值
    u2 = double(n2)*h(T:255)' / s2; %前景灰度均值

    differ = uint8(u2-u1);
end
