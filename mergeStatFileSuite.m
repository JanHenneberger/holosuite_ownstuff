function outFile = mergeStatFileSuite(statFile)


%load the file and merge them together
for cnt = 1:numel(statFile)
    fprintf('Merge Statistik File: %04u / %04u\n',cnt, numel(statFile) );
    temp = statFile{cnt};
    
    temp.ManchCDPConcArrayMean = temp.ManchCDPConcArrayMean';
    temp.ManchCDPConcArrayStd = temp.ManchCDPConcArrayStd';
    
    if ~exist('outFile','var')
        outFile = temp;
        
        copyFields = fieldnames(outFile);
        copyFields = copyFields(~strcmp(copyFields,'sample'));
        copyFields = copyFields(~strcmp(copyFields,'water'));
        copyFields = copyFields(~strcmp(copyFields,'ice'));
        copyFields = copyFields(~strcmp(copyFields,'artefact'));
        copyFields = copyFields(~strcmp(copyFields,'Parameter'));
        copyFields = copyFields(~strcmp(copyFields,'meanIntervall')); 
        
        sampleFields  = fieldnames(outFile.sample);
        waterFields  = fieldnames(outFile.water);
        iceFields  = fieldnames(outFile.ice);
        artefactFields  = fieldnames(outFile.artefact);
        ParameterFields  = fieldnames(outFile.Parameter);


    else        
        for cnt2 = 1:numel(copyFields)
            outFile.(copyFields{cnt2}) = [outFile.(copyFields{cnt2}) temp.(copyFields{cnt2})];
        end
        for cnt2 = 1:numel(sampleFields)
            outFile.sample.(sampleFields{cnt2}) = [outFile.sample.(sampleFields{cnt2}) ...
                temp.sample.(sampleFields{cnt2})];
        end
        for cnt2 = 1:numel(waterFields)
            outFile.water.(waterFields{cnt2}) = [outFile.water.(waterFields{cnt2}) ...
                temp.water.(waterFields{cnt2})];
        end
        for cnt2 = 1:numel(iceFields)
            outFile.ice.(iceFields{cnt2}) = [outFile.ice.(iceFields{cnt2}) ...
                temp.ice.(iceFields{cnt2})];
        end
        for cnt2 = 1:numel(artefactFields)
            outFile.artefact.(artefactFields{cnt2}) = [outFile.artefact.(artefactFields{cnt2}) ...
                temp.artefact.(artefactFields{cnt2})];
        end

        
        clear temp
    end
end









