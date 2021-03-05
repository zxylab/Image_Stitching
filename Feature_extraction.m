function [matchedPoints1, matchedPoints2] = Feature_extraction(Image1,Image2)

Gray_Image1= rgb2gray(Image1); %��ת��Ϊ�Ҷ�ͼ
Gray_Image2= rgb2gray(Image2);

%�������
points1=detectSURFFeatures(Gray_Image1); % ������ Harris or SURF or FAST 
points2=detectSURFFeatures(Gray_Image2); 

[features1, valid_points1] = extractFeatures(Gray_Image1,points1); % ��������
[features2, valid_points2] = extractFeatures(Gray_Image2,points2); 

%����ƥ��
indexPairs = matchFeatures(features1,features2, 'Unique', true); %Ѱ�Ҷ�Ӧ�� 
matchedPoints1 = valid_points1(indexPairs(:,1));
matchedPoints2 = valid_points2(indexPairs(:,2));

showMatchedFeatures(Image1,Image2,...
   matchedPoints1,matchedPoints2,'montage');title('��ƥ���������');

end

