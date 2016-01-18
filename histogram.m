function [number, edges, middle, limit, error] = histogram(data, sampleVolume, varargin) 

if nargin == 3
    edges =  varargin{1};
    
else
    bins = 20;
    edges = logspace(log10(3),log10(150),bins);
end

tmp = edges;
tmp(1) = [];
edges(end) = [];
edgesSize = log(tmp) - log(edges);
middle = (tmp + edges)/2;

number = histc(data,edges)./sampleVolume./1000000./edgesSize;
error = (histc(data,edges).^(1/2))./sampleVolume./1000000./edgesSize;
limit = ones(1,numel(number))./sampleVolume./1000000./edgesSize;