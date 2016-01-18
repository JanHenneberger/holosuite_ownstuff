asFilesNames = dir(['H-' '*_as.mat']);
asFilesNames = {asFilesNames.name};

for cnt = 8:numel(asFilesNames)
    fprintf('Correct Particle Statistik File: %04u / %04u\n',cnt, numel(asFilesNames) );
    asFileOld = load(asFilesNames{cnt});
    asFileOld = asFileOld.outFile;
    
    outFile = correctParDate(asFileOld);
    
    save(asFilesNames{cnt},'outFile','-v7.3');
end

