allFiles = dir('*_10sec*');
allFiles = {allFiles.name;};

    for cnt =1:numel(allFiles)
        cnt
        anDataIn = load(allFiles{cnt});
        anDataIn = anDataIn.anDataAll;
        
        copyFields              = fieldnames(anDataIn);
        for cnt2 = 1:numel(copyFields)
            if ~iscell(anDataIn.(copyFields{cnt2}))
              anDataOut{cnt}.(copyFields{cnt2})=  anDataIn.(copyFields{cnt2});
            end
        end
%         for cnt2 = 1:numel(anDataIn.sample)
%             anDataOut{cnt}.Number(cnt2)=anDataIn.sample{1,cnt2}.Number;
%             anDataOut{cnt}.NumberReal(cnt2)=anDataIn.sample{1,cnt2}.NumberReal;
%             anDataOut{cnt}.sampleVolumeAll(cnt2)=anDataIn.sample{1,cnt2}.VolumeAll;
%             anDataOut{cnt}.sampleVolumeReal(cnt2)=anDataIn.sample{1,cnt2}.VolumeReal;
%         end

       anDataOut{cnt}.meanIntervall = str2num(allFiles{cnt}(find(allFiles{cnt}=='_')+1:find(allFiles{cnt}=='s')-1));
        
        
    end
       save('Clean_100sec','anDataOut')
