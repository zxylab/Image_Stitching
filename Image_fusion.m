function [Image,row] = Image_fusion(Rgb_Image1,Rgb_Image2,tform,ans_to_LR)

row=0; %����ֵ������������ʱû�з���ֵ

Gray_Image2=rgb2gray(Rgb_Image2); 

ImageSize=size(Gray_Image2); % ��ȡͼƬ��С

[xlim, ylim] = outputLimits(tform, [1 ImageSize(2)], [1 ImageSize(1)]); % ���Ҽ��α任���������

xMin = min([1; xlim(:)]); % ����(1��xlim)�е���Сֵ
xMax = max([ImageSize(2); xlim(:)]); % ����ͼ��������xlim�е����ֵ
 
yMin = min([1; ylim(:)]); % ����(1��ylim)�е���Сֵ
yMax = max([ImageSize(1); ylim(:)]); % ����ͼ��(�߶ȣ�ylim)�е����ֵ

% ȷ��ȫ��ͼ�Ŀ��
width  = round(xMax - xMin); % round(X):��X��ÿ��Ԫ�����뵽��ӽ���������
height = round(yMax - yMin);

%����2D�ռ�ο�������ȫ��ͼ�ߴ�
xLimits = [xMin xMax]; % ����ƴ��
yLimits = [yMin yMax];

%imref2d : ����xLimits, yLimits�ı���ȷ�����͸ߵ�����,panoramaViewȷ�������ű���
panoramaView = imref2d([ height width ], xLimits, yLimits);  % height,width: ͼ���С��xLimits,yLimits:ͼ��Χ


% �任ͼƬ��ȫ��ͼ.
if (ans_to_LR==1)
    Image1 = imwarp(Rgb_Image1,projective2d(eye(3)), 'OutputView', panoramaView);
    Image2 = imwarp(Rgb_Image2, tform, 'OutputView', panoramaView); % �����α任���õ�ͼ��   
else
    Image2 = imwarp(Rgb_Image1,projective2d(eye(3)), 'OutputView', panoramaView);
    Image1 = imwarp(Rgb_Image2, tform, 'OutputView', panoramaView); % �����α任���õ�ͼ�� 
end
% figure;imshow(Image1);title('�任ͼƬ');figure;imshow(Image2);title('��׼ͼƬ');
%Image=Image1+Image2;
%figure; imshow(Image);title('ֱ��ƴ�ӵ�ͼƬ');

%==========================���뽥��ƴ��ͼ��================================
%��һ��ƴ��
width2=size(Image1,2); %��ȡͼ���/��������
height2=size(Image1,1); 
% Image1=im2double(Image1);Image2=im2double(Image2);
d1=0:1/(width2-1):1;
D1=repmat(d1,height2,1);
D2=fliplr(D1); %��D1����
Image1=im2double(Image1);Image2=im2double(Image2);
Image=(D2.*Image1+D1.*Image2); % D1 D2:��Ȩϵ��

%figure; imshow(Image);
%�Ա�Ե���ٴδ���ƴ��
if (mod(width2,2)==1) % �ж���ż��
    % ͼƬ��Ϊ����
    Croped_D1=imcrop(D1,[1,1,((width2+1)/2)-1,height2-1]); % ��D1�ü���hat�������ߵ���ʽ
    %Croped_D2=fliplr(Croped_D1);  % ��D1ȡ����Ϊhat�����Ұ�ߵ���ʽ
    Croped_D2=imcrop(D2,[((width2+1)/2)+1,1,(width2+1)-2,height2-1]);
    D=[Croped_D1 Croped_D2];
    Image0=(abs(Image1-Image2))/2;
    Image0=2*D.*Image0;
    Image=Image+Image0;    
else
    % ͼƬ��Ϊż��
    Croped_D1=imcrop(D1,[1,1,(width2/2)-1,height2-1]); % ��D1�ü���hat�������ߵ���ʽ
    Croped_D2=fliplr(Croped_D1);  % ��D1ȡ����Ϊhat�����Ұ�ߵ���ʽ
    D=[Croped_D1 Croped_D2];
    Image0=(abs(Image1-Image2))/2;
    Image0=2*D.*Image0;
    Image=Image+Image0;
end
%figure; imshow(Image);title('���뽥����ƴ�Ӻ��ͼƬ');

end


