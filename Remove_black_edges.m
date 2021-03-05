function [panorama] = Remove_black_edges(panorama,ImageSize,Odd_even)

ImageSize_panorama=size(panorama); % ��ȡȫ��ͼ��С
%==================��ȡͼ��׼ͼƬ�ڿ�Ŀ���======================
%ImageSize_Image1=size(Image1); % ��ȡ��׼ͼƬ��С
n=(ImageSize_panorama(2)); % ��ȡ��׼ͼƬ�м��е�λ��
n=n/2; 
if (Odd_even==0)
    n=n/2; %ͼƬΪż����ʱ��ȡͼƬ1/4������
else
end
m=ImageSize_panorama(1); % m:����
m=m/2;
n=round(n);m=round(m);


%==================Step 1 ����ͼ�����ºڱߵĸ�=====================
Gray_panorama=rgb2gray(panorama); % rgbͼ��ȡ�ľ����һ��Ϊ����
row=Gray_panorama(:,n); % ��ȡ��׼ͼƬ�м��У���n�У�
row(m)=1; % ��ֹͼƬ�м�Ϊȫ0������row=row(1)ȡ������
[row] = find(row);  % [row,col,v] = find(Image1); �����꣬�����ֵ꣬�� find: ���ҷ�0Ԫ��
row=row(1); % ��һ����0Ԫ�����ڵ��У�Ҳ���ǻ�׼ͼƬ���ڵ�����
if (row==m)
    row=0; % ����ȫ0�������row(m/2)=1���ӵ����޳�
else
end    


panorama=imcrop(panorama,[1,row+1,ImageSize_panorama(2)-1,ImageSize(1)]);
%panorama=imcrop(panorama,[col_left,row+1,col_right-1,ImageSize(1)]);

% figure; imshow(panorama);title('ƴ�Ӻ��ȫ��ͼ');

%==================Step 2 ����ͼ�����ڱߵĳ���===================

%=====��ȡͼ��׼ͼƬ�ڿ�Ŀ���======
ImageSize_panorama=size(panorama);
n=(ImageSize_panorama(2)); % ��ȡ��׼ͼƬ�м��е�λ��
n=n/2; 
m=ImageSize_panorama(1); % m:����
m=m/2;
n=round(n);m=round(m);

Gray_panorama=rgb2gray(panorama); % rgbͼ��ȡ�ľ����һ��Ϊ����
col_1=Gray_panorama(1,:);
col_2=Gray_panorama(m,:); % ��ȡͼƬ��һ�к����һ��

%col_1(n)=1;
%col_2(n)=1;
        
[col_1]=find(col_1);
[col_2]=find(col_2); % ����ͼƬ��һ�к����һ�е����з�0ֵ��λ��
        
col_11=col_1(1);
col_12=col_2(1); % ����ͼƬ��һ�к����һ�еĵ�һ����0ֵ��λ�ã���ͼƬ���ڱ߿��ܵ�λ��
col_left=max(col_11,col_12);% ����ͼƬ������ȡ�Ŀ��
%==================Step 3 ����ͼ���Ҳ�ڱߵĳ���===================
[col_1]=fliplr(col_1);
[col_2]=fliplr(col_2); % ���ҷ�ת��������ȡ�Ҳ��0Ԫ��λ��
col_21=col_1(1);
col_22=col_2(1); % ����ͼƬ��һ�к����һ�е��Ҳ����һ����0ֵ��λ�ã���ͼƬ�Ҳ�ڱ߿��ܵ�λ��
col_right=min(col_21,col_22); % ����ͼƬ�Ҳ�ڱ����꣨�����ǿ�ȣ�


panorama=imcrop(panorama,[col_left,1,col_right-col_left-1,ImageSize_panorama(1)-1]);

end

