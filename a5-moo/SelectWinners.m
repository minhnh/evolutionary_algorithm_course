function winners = SelectWinners(obj, selection_size)
%SELECTWINNERS Summary of this function goes here
%   Detailed explanation goes here

winners = obj.Population;
numGene = length(winners(1).Genome);
for i = 1 : selection_size
    winners(i).numLeadingZeros = find(winners(i).Genome, 1, 'first') - 1;
    winners(i).numTrailingOnes = numGene - find(~winners(i).Genome, 1, 'last');
end

end

