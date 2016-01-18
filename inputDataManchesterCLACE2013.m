cdp = importdata('cdp10secs.csv',',',2);
cdp.textdata = cdp.textdata(3:end-1);
for cnt=1:numel(cdp.data)
    cnt
cdp.dateNum(cnt) = datenum(cdp.textdata(cnt),'dd/mm/yyyy HH:MM:SS')
end


