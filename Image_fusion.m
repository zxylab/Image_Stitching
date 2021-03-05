function [Image,row] = Image_fusion(Rgb_Image1,Rgb_Image2,tform,ans_to_LR)

row=0; %赋初值，否则函数运行时没有返回值

Gray_Image2=rgb2gray(Rgb_Image2); 

ImageSize=size(Gray_Image2); % 读取图片大小

[xlim, ylim] = outputLimits(tform, [1 ImageSize(2)], [1 ImageSize(1)]); % 查找几何变换的输出限制

xMin = min([1; xlim(:)]); % 返回(1，xlim)中的最小值
xMax = max([ImageSize(2); xlim(:)]); % 返回图像列数，xlim中的最大值
 
yMin = min([1; ylim(:)]); % 返回(1，ylim)中的最小值
yMax = max([ImageSize(1); ylim(:)]); % 返回图像(高度，ylim)中的最大值

% 确定全景图的宽高
width  = round(xMax - xMin); % round(X):将X的每个元素舍入到最接近的整数。
height = round(yMax - yMin);

%创建2D空间参考对象定义全景图尺寸
xLimits = [xMin xMax]; % 横向拼接
yLimits = [yMin yMax];

%imref2d : 根据xLimits, yLimits的比例确定长和高的缩放,panoramaView确定了缩放比例
panoramaView = imref2d([ height width ], xLimits, yLimits);  % height,width: 图像大小。xLimits,yLimits:图象范围


% 变换图片到全景图.
if (ans_to_LR==1)
    Image1 = imwarp(Rgb_Image1,projective2d(eye(3)), 'OutputView', panoramaView);
    Image2 = imwarp(Rgb_Image2, tform, 'OutputView', panoramaView); % 将几何变换运用到图象   
else
    Image2 = imwarp(Rgb_Image1,projective2d(eye(3)), 'OutputView', panoramaView);
    Image1 = imwarp(Rgb_Image2, tform, 'OutputView', panoramaView); % 将几何变换运用到图象 
end
% figure;imshow(Image1);title('变换图片');figure;imshow(Image2);title('基准图片');
%Image=Image1+Image2;
%figure; imshow(Image);title('直接拼接的图片');

%==========================渐入渐出拼接图象================================
%第一次拼接
width2=size(Image1,2); %获取图像宽/矩阵列数
height2=size(Image1,1); 
% Image1=im2double(Image1);Image2=im2double(Image2);
d1=0:1/(width2-1):1;
D1=repmat(d1,height2,1);
D2=fliplr(D1); %把D1倒序
Image1=im2double(Image1);Image2=im2double(Image2);
Image=(D2.*Image1+D1.*Image2); % D1 D2:加权系数

%figure; imshow(Image);
%对边缘带再次处理并拼接
if (mod(width2,2)==1) % 判断奇偶性
    % 图片宽为奇数
    Croped_D1=imcrop(D1,[1,1,((width2+1)/2)-1,height2-1]); % 把D1裁剪成hat函数左半边的形式
    %Croped_D2=fliplr(Croped_D1);  % 把D1取反变为hat函数右半边的形式
    Croped_D2=imcrop(D2,[((width2+1)/2)+1,1,(width2+1)-2,height2-1]);
    D=[Croped_D1 Croped_D2];
    Image0=(abs(Image1-Image2))/2;
    Image0=2*D.*Image0;
    Image=Image+Image0;    
else
    % 图片宽为偶数
    Croped_D1=imcrop(D1,[1,1,(width2/2)-1,height2-1]); % 把D1裁剪成hat函数左半边的形式
    Croped_D2=fliplr(Croped_D1);  % 把D1取反变为hat函数右半边的形式
    D=[Croped_D1 Croped_D2];
    Image0=(abs(Image1-Image2))/2;
    Image0=2*D.*Image0;
    Image=Image+Image0;
end
%figure; imshow(Image);title('渐入渐出法拼接后的图片');

end


