function [panorama] = Remove_black_edges(panorama,ImageSize,Odd_even)

ImageSize_panorama=size(panorama); % 获取全景图大小
%==================获取图基准图片黑框的宽，高======================
%ImageSize_Image1=size(Image1); % 获取基准图片大小
n=(ImageSize_panorama(2)); % 获取基准图片中间列的位置
n=n/2; 
if (Odd_even==0)
    n=n/2; %图片为偶数个时获取图片1/4处的列
else
end
m=ImageSize_panorama(1); % m:行数
m=m/2;
n=round(n);m=round(m);


%==================Step 1 计算图象上下黑边的高=====================
Gray_panorama=rgb2gray(panorama); % rgb图获取的矩阵第一行为三行
row=Gray_panorama(:,n); % 获取基准图片中间列（第n列）
row(m)=1; % 防止图片中间为全0，导致row=row(1)取不到数
[row] = find(row);  % [row,col,v] = find(Image1); 行坐标，列坐标，值。 find: 查找非0元素
row=row(1); % 第一个非0元素所在的行，也就是基准图片所在的行数
if (row==m)
    row=0; % 出现全0情况，把row(m/2)=1增加的数剔除
else
end    


panorama=imcrop(panorama,[1,row+1,ImageSize_panorama(2)-1,ImageSize(1)]);
%panorama=imcrop(panorama,[col_left,row+1,col_right-1,ImageSize(1)]);

% figure; imshow(panorama);title('拼接后的全景图');

%==================Step 2 计算图象左侧黑边的长度===================

%=====获取图基准图片黑框的宽，高======
ImageSize_panorama=size(panorama);
n=(ImageSize_panorama(2)); % 获取基准图片中间列的位置
n=n/2; 
m=ImageSize_panorama(1); % m:行数
m=m/2;
n=round(n);m=round(m);

Gray_panorama=rgb2gray(panorama); % rgb图获取的矩阵第一行为三行
col_1=Gray_panorama(1,:);
col_2=Gray_panorama(m,:); % 读取图片第一行和最后一行

%col_1(n)=1;
%col_2(n)=1;
        
[col_1]=find(col_1);
[col_2]=find(col_2); % 给出图片第一行和最后一行的所有非0值的位置
        
col_11=col_1(1);
col_12=col_2(1); % 给出图片第一行和最后一行的第一个非0值的位置，即图片左侧黑边可能的位置
col_left=max(col_11,col_12);% 给出图片左侧需截取的宽度
%==================Step 3 计算图象右侧黑边的长度===================
[col_1]=fliplr(col_1);
[col_2]=fliplr(col_2); % 左右翻转，方便提取右侧非0元素位置
col_21=col_1(1);
col_22=col_2(1); % 给出图片第一行和最后一行的右侧最后一个非0值的位置，即图片右侧黑边可能的位置
col_right=min(col_21,col_22); % 给出图片右侧黑边坐标（而不是宽度）


panorama=imcrop(panorama,[col_left,1,col_right-col_left-1,ImageSize_panorama(1)-1]);

end

