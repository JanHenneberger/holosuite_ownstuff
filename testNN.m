% rootFolder ='C:\Users\janhe\Desktop\10_28_Particle_Images2\';
% 
% folders = {'AggregationAbs', 'SmallIceAbs','IceAbs', 'SmallWaterAbs', 'WaterAbs'};
% data = [];
% cat = zeros(5,3239);
% cntFiles = 1;
% for cnt = 1:numel(folders)
%    files = dir([fullfile(rootFolder,folders{cnt}) '\*.png']);
%    files  ={files.name};
%    for cnt2 = 1:numel(files)       
%       imData = imread(fullfile(rootFolder,folders{cnt},files{cnt2}));
%       imData = imData(min(imData,[],2)<255, min(imData)<255);
%       imData =  imresize(imData,[50,50]);
%       imData = imData(:);
%       data(:,end+1) = imData;
%       cat(cnt,cntFiles) = 1; 
%       cntFiles = cntFiles+1;
%    end
%    
% end

X = temp1.X;

Y = temp1.Y;
Y2 = grp2idx(Y);
Y5 = [Y2 == 1, Y2 == 2, Y2 == 3, Y2 == 4];

for  cnt = numel(Y)
    imData1 = abs(temp1.prtclIm{cnt});  
    imData1 =  imresize(imData1,[30,30]);
    imData2 = angle(temp1.prtclIm{cnt});
    imData2 =  imresize(imData2,[30,30]);
    imData = [imData1; imData2];
    imDataAll(cnt,:) = imData(:);
end
im = temp1.prtclIm;
%add stupid message
%add a second message

%add a third message