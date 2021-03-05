%function Image_Stitching(selpath)
tic
file = fullfile('C:\Users\zhuxi\Desktop\test\'); %'C:\Users\12786\Desktop\test2\'   selpath
image_file = imageDatastore(file);
N= numel(image_file.Files); % NΪͼƬ����
% montage(image_file.Files); %��ʾͼƬ
Image1 = readimage(image_file, 1);Image2 = readimage(image_file, 2);Image3 = readimage(image_file, 3);
figure;subplot(1,3,1);imshow(Image1);
subplot(1,3,2);imshow(Image2);
subplot(1,3,3);imshow(Image3);

Image1 = readimage(image_file, 1);
ImageSize=size(Image1); % ȷ��ͼƬ��С
Number = mod(N,2);
if( Number == 1)
    Odd_even=1; % ����
else
    Odd_even=0; % ż��
end

for j=1:N-1   
%======��ƴ��======
n=floor((N+1)/2); %nΪ��׼ͼ��λ��

if (j==1)
    Image1 = readimage(image_file, n); % ȷ����׼ͼ��
else
    Image1=panorama;
end

if (n-j>0)
    Image2 = readimage(image_file,n-j); % ƴ���
    ans_to_LR=0;
else
    Image2 = readimage(image_file,j+1); % ƴ�ұ�,  j+1:ƴ�����j������n-1
    ans_to_LR=1;
end  

figure;  
%=========================��������ȡ��ƥ��=================================

[matchedPoints1, matchedPoints2] = Feature_extraction(Image1,Image2);

%=====================�ų��쳣�����㣬���任����=========================

[tform,Filtered_matchedPoints2,Filtered_matchedPoints1] = ...
    estimateGeometricTransform(matchedPoints2,matchedPoints1,'projective', 'Confidence', 99.9);  %��������ת������'similarity'��2��'affine'��3��'projective'��4��ƥ��ĵ�Ե�����Խ�󣬹��Ƶı任��׼ȷ��Խ�ߡ�

showMatchedFeatures(Image1,Image2,...
	Filtered_matchedPoints1,Filtered_matchedPoints2,'montage');title('SURF�㷨��ȡ��������');

%================================ͼ���ں�==================================
%�ж��Ƿ�ƴ������ͼƬ��gate��ȥ���ڱ�ʹ��
[panorama] = Image_fusion(Image1,Image2,tform,ans_to_LR);

% figure; imshow(panorama);title('FAST�㷨ƴ�Ӻ��ͼ��');


end

%========================ȥ��ȫ��ͼ�ĺڱ�(���п���)========================

[panorama] = Remove_black_edges(panorama,ImageSize,Odd_even);


figure; imshow(panorama);title('SURF�㷨ƴ�Ӻ��ͼ��');
toc

%end

