%function Image_Stitching(selpath)
tic
file = fullfile('C:\Users\zhuxi\Desktop\test\'); %'C:\Users\12786\Desktop\test2\'   selpath
image_file = imageDatastore(file);
N= numel(image_file.Files); % N为图片数量
% montage(image_file.Files); %显示图片
Image1 = readimage(image_file, 1);Image2 = readimage(image_file, 2);Image3 = readimage(image_file, 3);
figure;subplot(1,3,1);imshow(Image1);
subplot(1,3,2);imshow(Image2);
subplot(1,3,3);imshow(Image3);

Image1 = readimage(image_file, 1);
ImageSize=size(Image1); % 确定图片大小
Number = mod(N,2);
if( Number == 1)
    Odd_even=1; % 奇数
else
    Odd_even=0; % 偶数
end

for j=1:N-1   
%======先拼左======
n=floor((N+1)/2); %n为基准图象位置

if (j==1)
    Image1 = readimage(image_file, n); % 确定基准图像
else
    Image1=panorama;
end

if (n-j>0)
    Image2 = readimage(image_file,n-j); % 拼左边
    ans_to_LR=0;
else
    Image2 = readimage(image_file,j+1); % 拼右边,  j+1:拼完左边j自增了n-1
    ans_to_LR=1;
end  

figure;  
%=========================特征点提取与匹配=================================

[matchedPoints1, matchedPoints2] = Feature_extraction(Image1,Image2);

%=====================排除异常特征点，求解变换矩阵=========================

[tform,Filtered_matchedPoints2,Filtered_matchedPoints1] = ...
    estimateGeometricTransform(matchedPoints2,matchedPoints1,'projective', 'Confidence', 99.9);  %可以设置转换类型'similarity'：2，'affine'：3或'projective'：4。匹配的点对的数量越大，估计的变换的准确度越高。

showMatchedFeatures(Image1,Image2,...
	Filtered_matchedPoints1,Filtered_matchedPoints2,'montage');title('SURF算法提取的特征点');

%================================图像融合==================================
%判断是否拼完整张图片，gate给去除黑边使用
[panorama] = Image_fusion(Image1,Image2,tform,ans_to_LR);

% figure; imshow(panorama);title('FAST算法拼接后的图像');


end

%========================去除全景图的黑边(可有可无)========================

[panorama] = Remove_black_edges(panorama,ImageSize,Odd_even);


figure; imshow(panorama);title('SURF算法拼接后的图像');
toc

%end

