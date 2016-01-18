function [ anData ] = includeCottonRelation( anData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
 anData.IWMeanDFixRho = anData.IWMeanD;
   anData.IWMeanD = anData.IWMeanMaxD; 
    
   anData.IWMeanDRawFixRho = anData.IWMeanDRaw;
   anData.IWMeanDRaw = anData.IWMeanMaxDRaw; 
   
   anData.IWCountRawFixRho = anData.IWCountRaw;
   anData.IWCountRaw = anData.IWCountRawMaxDia;
   
   anData.IWCountFixRho = anData.IWCount;
   anData.IWCount = anData.IWCountMaxDia;
   
   anData.IWConcentractionFixRho = anData.IWConcentraction;
   anData.IWConcentraction = anData.IWConcentractionMaxDia;
      
   anData.IWContentRawFixRho = anData.IWContentRaw;
   anData.IWContentRaw = anData.IWContentRawCotton;
   
   anData.IWContentFixRho = anData.IWContent;
   anData.IWContent = anData.IWContentCotton;
   
   anData.TWCountRawFixRho = anData.TWCountRaw;
   anData.TWCountRaw = anData.TWCountRawMaxDia;
   
   anData.TWCountFixRho = anData.TWCount;
   anData.TWCount = anData.TWCountMaxDia;
   
   anData.TWConcentractionFixRho = anData.TWConcentraction;
   anData.TWConcentraction = anData.TWConcentractionMaxDia;
      
   anData.TWContentRawFixRho = anData.TWContentRaw;
   anData.TWContentRaw = anData.TWContentRawCotton;
   
   anData.TWContentFixRho = anData.TWContent;
   anData.TWContent = anData.TWContentCotton;

end

