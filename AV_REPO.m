data_path= '/Users/Michele/Desktop/4D_HSI/ToF/';
show = 0;
calibration = 0;

data_name=[data_path,'test2006_range_gray.tiff'];

depth_image = double(imread (data_name));

ptCloud = pcread([data_path,'test2006_intensity.ply']);

%% convert depth to plc
[x,y] = find(depth_image);

depth_min = min(min(depth_image));
depth_max = max(max(depth_image));

Z = (depth_min + depth_image./65535 * (depth_max - depth_min))./10;

for i=1:length(x)
    
    X(x(i),y(i)) = x(i);
    Y(x(i),y(i)) = y(i);
    
end
% Z1=Z;
% Z1(find(Z>=50))=50;
pnts = cat(3,X,Y,Z);
Z_=Z; Z_(Z_==0)=1123;
Z_(Z_>800)=800;
pnts_= cat(3,X,Y,Z_);
pc = pointCloud(pnts_);
%%
%% Display
if show ==1

    pnts_patial = pnts_(193:314,181:296,:);
    pc_patial = pointCloud(pnts_patial);
    figure;pcshow(pc_patial);
    xlim([188 319]); ylim([176 291]);

    pnts_1 = cat(3,X,Y,double(registered_hsi(:,:,1))./1000);
    pc_1 = pointCloud(pnts_1(68:318,75:331,:));
    pcshow(pnts_1(68:318,75:331,:),[1 0 0]);
    hold on;


    pnts_2 = cat(3,X,Y,double(registered_hsi(:,:,50))./2000);
    pc_2 = pointCloud(pnts_2(68:318,75:331,:));
    pcshow(pnts_2(68:318,75:331,:),[0 1 0]);
    hold on;

% colors = cat(3,double(registered_hsi(:,:,1)),double(registered_hsi(:,:,45)),double(registered_hsi(:,:,120)));
% colors = cat(3,double(registered_hsi(:,:,1)),zeros(480,640,1),zeros(480,640,1));
% colors = colors./65535;
    figure;
    subplot(1,3,1);
    A = registered_hsi;
    A(A>10000)=0;
    colors = A(193:314,181:296,73);%(:,:,58)
    pcshow(pnts_patial,colors);
    xlim([188 319]); ylim([176 291]);
    title('Red Wavelength (625~740nm)');
    subplot(1,3,2);
    colors = registered_hsi(:,:,38);
    pcshow(pnts_,colors);
    % xlim([188 319]); ylim([176 291]);
    title('Green Wavelength (550~565nm)');
    subplot(1,3,3);
    colors = registered_hsi(:,:,5);
    pcshow(pnts_,colors);
    % xlim([188 319]); ylim([176 291]);
    title('Blue Wavelength (450~485nm)');
   
    figure;
    subplot(1,3,1);
    colors = registered_hsi(:,:,1);%(193:314,181:296,58);
    pcshow(pnts_,colors);
    %xlim([188 319]); ylim([176 291]);
    title('Chlorophyll aborbing bottom (around 440nm)');
    subplot(1,3,2);
    colors = registered_hsi(:,:,39);
    pcshow(pnts_,colors);
    % xlim([188 319]); ylim([176 291]);
    title('Chlorophyll sensitive peak (around 540nm)');
    subplot(1,3,3);
    colors = registered_hsi(:,:,73);
    pcshow(pnts_,colors);
    % xlim([188 319]); ylim([176 291]);
    title('Cell tissue sensitive peak (after 800nm)');
    
    figure;
    subplot(2,2,1);
    colors = registered_hsi(:,:,73);
    pcshow(pnts_,colors);
    title('HSI data mapped on 3D space');
    subplot(2,2,2);
    A = registered_hsi;
    A(A>2000)=0;
    colors = A(193:314,181:296,1);%(:,:,58)
    pcshow(pnts_patial,colors);
    xlim([188 319]); ylim([176 291]);
    title('Chlorophyll aborbing bottom (around 440nm)');
    subplot(2,2,3);
    figure;
    A = registered_hsi;
    A(A>5000)=0;
    colors = A(193:314,181:296,39);%(:,:,58)
    pcshow(pnts_patial,colors);
    xlim([188 319]); ylim([176 291]);
    title('Chlorophyll sensitive peak (around 540nm)');
    subplot(2,2,4);
    figure;
    A = registered_hsi;
    A(A>8000)=0;
    colors = A(193:314,181:296,73);%(:,:,58)
    pcshow(pnts_patial,colors);
    xlim([188 319]); ylim([176 291]);
    title('Cell tissue sensitive peak (after 800nm)');

end
%%

hsi_path = '/Users/Michele/Desktop/4D_HSI/HSI/';
hsi_image = imread('/Users/Michele/Desktop/4D_HSI/HSI/Auto019.jpg');
%% Calibration
if calibration == 1
    mainf=imshow(hsi_image);
    [x, y ] = ginput(8);

    mainf=imshow([data_path,'test2005_intensity.tiff']);
    [x_d, y_d ] = ginput(8);


    moving_points = [x,y];
    fixed_points = [x_d,y_d];

    t_concord = cp2tform(moving_points,fixed_points,'projective');
end
%%

%% Information of fixed image
info = imfinfo([data_path,'test2005_intensity.tiff']);

registered = imtransform(hsi_image,t_concord,...
    'XData',[1 info.Width], 'YData',[1 info.Height]);


figure;imshow(registered);

hsi_cube = flip(imread('/Users/Michele/Desktop/4D_HSI/HSI/Auto021.tiff'));

registered_hsi = imtransform(hsi_cube,t_concord,...
    'XData',[1 info.Width], 'YData',[1 info.Height]);