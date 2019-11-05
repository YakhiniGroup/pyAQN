function [qM,binassignmat] = quantnorm(M)
%QUANTNORM Adjusted Quantile Normalization
%   Takes as input a double array, can include NaNs.
%   Applies jitter and binning to quantiles. Returns median per quantile.
    nans=isnan(M);
    jitteredM=M+randn(size(M)).*0.1;
    cM=num2cell(jitteredM,1);
    prctiles=cellfun(@(x) prctile(x,0:100), cM,'uniformoutput',false);     
    [numperbin,binassignments]=cellfun(@(x,y) histc(x,y),cM, prctiles,'uniformoutput',false);
    binassignmat = cell2mat(binassignments);
    qM=nan(size(M));
    for p=1:length(prctiles{1})
        qM(binassignmat==p) = median(jitteredM(binassignmat==p));
    end
    qM(nans)=nan;
end

