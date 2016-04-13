rootFolder ='C:\Users\janhe\Desktop\10_28_Particle_Images2\';

folders = {'AggregationAbs', 'SmallIceAbs','IceAbs', 'SmallWaterAbs', 'WaterAbs'};
data = [];
cat = zeros(5,3239);
cntFiles = 1;
for cnt = 1:numel(folders)
   files = dir([fullfile(rootFolder,folders{cnt}) '\*.png']);
   files  ={files.name};
   for cnt2 = 1:numel(files)       
      imData = imread(fullfile(rootFolder,folders{cnt},files{cnt2}));
      imData = imData(min(imData,[],2)<255, min(imData)<255);
      imData =  imresize(imData,[50,50]);
      imData = imData(:);
      data(:,end+1) = imData;
      cat(cnt,cntFiles) = 1; 
      cntFiles = cntFiles+1;
   end
   
end

%add stupid message
%add a second message

%add a third message