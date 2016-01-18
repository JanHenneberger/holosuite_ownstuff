function addTrStats

filenames = dir('*_ms.mat');
filenames = {filenames.name};
ishpsfiles =  cellfun(@(x) strcmp(x(1:2),'H-'), filenames);

hpsfilenames   = filenames(ishpsfiles);
psfilenames   = filenames(~ishpsfiles);

psfileint = numel(psfilenames);

parfor file =1:numel(psfilenames)
    newhpsfilename = ['H-' psfilenames{file}];
    
    if sum(ismember(hpsfilenames, newhpsfilename))==0
        data = load(psfilenames{file});
        data = data.outFile;
        if isstruct(data)
            for cnt = 1:numel(data.pStats.rtDp)
                radst = particleForRtStats.getRadTrStats(data.pStats.pImage{cnt},....
                    data.pStats.imCenterx(cnt),...
                    data.pStats.imCenterx(cnt));
                dr = sqrt(data.dx*data.dy);
                radst.rtrs(2)        = radst.rtrs(2) * dr;
                radst.rtBestFit(3:4) = radst.rtBestFit(3:4) *dr;
                radst.rtDp           = radst.rtDp *dr;
                radst.rtBSlope       = radst.rtBSlope *dr;
                radst.rtSignal       = radst.rtSignal *dr^2;
                data.pStats.rtrs{cnt} = radst.rtrs;
                data.pStats.rtBestFit{cnt} = radst.rtBestFit;
                data.pStats.rtDp(cnt) = radst.rtDp;
                data.pStats.rtBSlope(cnt) = radst.rtBSlope;
                data.pStats.rtSignal(cnt) = radst.rtSignal;
                data.pStats.rtGoodFit(cnt) = radst.rtGoodFit;
                data.pStats.rtAsym(cnt) = radst.rtAsym;
                data.pStats.rtCenterx(cnt) = radst.rtCenterx;
                data.pStats.rtCentery(cnt) = radst.rtCentery;
                if rem(cnt,100)==0
                    sprintf('Calculating rtStats from particle nr. %u / %u from ms file %u / %u',...
                        cnt, numel(data.pStats.rtDp), file, psfileint)
                end
            end
        end
        saveData(data,newhpsfilename);
    end
end

function saveData(data, name)
outFile = data;
save(name, 'outFile');