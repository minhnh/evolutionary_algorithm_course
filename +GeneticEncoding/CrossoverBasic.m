function children = CrossoverBasic( ~, selectedParents, crossoverParams )
%BASICCROSSOVER Perform a Simple Crossover operation
%   expect selectedParents to be a 2D matrix with each row being an individual
%   expect crossoverParams to contain 2 fields
%   - Rate: crossover rate - dictate number of children to be formed by crossover
%   - funcSingleCrossover: function to create one child from 2 parents
if ~isfield(crossoverParams, 'funcSingleCrossover') || ~isfield(crossoverParams, 'Rate')
    error(['CrossoverBasic function requires crossoverParams argument to have'...
           ' funcSingleCrossover and Rate fields']);
end

children = zeros(size(selectedParents));
numParents = size(selectedParents, 1);

% Crossover a number of parents based on rate
numCrossover = int32(crossoverParams.Rate * numParents);
parfor k = 1:numCrossover
    parentIndices = randperm(numParents, 2);
    children(k, :) = crossoverParams.funcSingleCrossover(selectedParents(parentIndices, :));
end

% Clone randomly selected parents to fill remaining slots
children(numCrossover + 1 : numParents, :) =...
        selectedParents(randi(numParents, 1, numParents - numCrossover), :);
            
end
