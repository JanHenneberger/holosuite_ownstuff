exportNames = {'Year'; 'Month'; 'Day'; 'Hour'; 'Minute'; 'Second'; 'DateNum';...
     'LWC'; 'IWC'};
tmp = anData20130207_100;
tmp2 = datevec(tmp.intTimeStart)';
exportTable = table(tmp2(1,:)', tmp2(2,:)', tmp2(3,:)', tmp2(4,:)', tmp2(5,:)',num2str(tmp2(6,:)','%2.0f'),...
    num2str(tmp.intTimeStart','%6.4f'), num2str(tmp.LWContent',2), num2str(tmp.IWContent',2),'VariableNames',exportNames);
writetable(exportTable,'JFJ20130207.txt')