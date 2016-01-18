function plot_Scatterplot(anData, cntFig)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
    figure(cntFig)
    X = [anData.measMeanT; ...
    anData.measMeanV;...
    log10(anData.meanD*1e6);...
    anData.TWConcentraction; ...
    anData.LWConcentraction; ...
    anData.IWConcentraction; ...
    anData.TWContent;...
    anData.LWContent;...
    anData.IWContent;...
    log10(anData.LWConcentraction./anData.TWConcentraction);...
    log10(anData.IWConcentraction./anData.TWConcentraction);...
    anData.LWContent./anData.TWContent;...
    anData.IWContent./anData.TWContent;...
    ]';
varNames = {'Air temperature [�C]'; ... %1
    'Air velocity [m s^{-1}]';...       %2
    'mean diameter [\mum]';...          %3
    'TW Conc. [cm^{-3}]';...            %4
    'LW Conc. [cm^{-3}]';...            %5
    'IW Conc. [cm^{-3}]';...            %6
    'TW Content [g m^{-3}]';...         %7
    'LW Content [g m^{-3}]';...         %8
    'IW Content [g m^{-3}]';...         %9
    'LW Conc./ TW Conc.';...            %10
    'IW Conc./ TW Conc.';...            %11
    'LW Content/ TW Content.';...       %12
    'IW Content/ TW Content';...        %13
    };

    choosenX = [1 3 7:9];
    choosenY = [1 3 7:9];
    choosenVarX = {varNames{choosenX}};
    choosenVarY = {varNames{choosenY}};
    %gplotmatrix(X(:,choosenX),X(:,choosenY),B,[],'o',4,'on','hist',choosenVarX, choosenVarY);
    gplotmatrix(X(:,choosenX),[],[] ,[],'o',4,'on','hist',choosenVarX, choosenVarX);

end

