 tmp=find(allData{1}.TWContent > 5 & allData{1}.isValidIntervall,2)
 [allData{1}.NumberReal(tmp)  allData{1}.NumberReal(tmp-1)  allData{1}.NumberReal(tmp+1)]
 [allData{1}.sampleVolumeReal(tmp)  allData{1}.sampleVolumeReal(tmp-1) allData{1}.sampleVolumeReal(tmp+1)] 
 [allData{1}.TWContent(tmp)  allData{1}.TWContent(tmp-1)  allData{1}.TWContent(tmp+1)]
 [allData{1}.TWCount(tmp)  allData{1}.TWCount(tmp-1)  allData{1}.TWCount(tmp+1)]
 [allData{1}.LWCount(tmp)  allData{1}.LWCount(tmp-1)  allData{1}.LWCount(tmp+1)]
 [allData{1}.IWCount(tmp)  allData{1}.IWCount(tmp-1)  allData{1}.IWCount(tmp+1)]
 [allData{1}.isValidIntervall(tmp)  allData{1}.isValidIntervall(tmp-1)  allData{1}.isValidIntervall(tmp+1)]
%  allData{1}.LWContent(tmp)
%  allData{1}.LWContent(tmp-1)
%  allData{1}.LWContent(tmp+1)
%  
%  allData{1}.IWContent(tmp)
%  allData{1}.IWContent(tmp-1)
%  allData{1}.IWContent(tmp+1)
 
  [allData{1}.TWContent(tmp)-allData{1}.LWContent(tmp)- allData{1}.IWContent(tmp) ... 
  allData{1}.TWContent(tmp-1)-allData{1}.LWContent(tmp-1)- allData{1}.IWContent(tmp-1) ...
  allData{1}.TWContent(tmp+1)-allData{1}.LWContent(tmp+1)- allData{1}.IWContent(tmp+1)]

  [allData{1}.TWContentRaw(tmp)-allData{1}.LWContentRaw(tmp)- allData{1}.IWContentRaw(tmp) ... 
  allData{1}.TWContentRaw(tmp-1)-allData{1}.LWContentRaw(tmp-1)- allData{1}.IWContentRaw(tmp-1) ...
  allData{1}.TWContentRaw(tmp+1)-allData{1}.LWContentRaw(tmp+1)- allData{1}.IWContentRaw(tmp+1)]