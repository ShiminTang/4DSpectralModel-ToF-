clear all;
% Load images.
imageDir = '/Users/Michele/Desktop/HSI_Stich/after';
GroundScene = imageSet(imageDir);

% Read the first image from the image set.

img1=read(GroundScene, 1);
img2=read(GroundScene, 2);

mosaic=sift_mosaic(img1,img2);

n=GroundScene.Count;

for i=3:n
    i
    img_next=read(GroundScene, i);
    mosaic=sift_mosaic(img_next,mosaic);
end
I=mosaic;

K=1;
T=I+(1-I).*I.*K;
figure; imagesc(I);



% T_ = rgb2gray(I);
% rgb = label2rgb(gray2ind(T_, 255), summer(255));
% figure; imshow(rgb);