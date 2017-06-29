function children = Mutate(obj, children, mutationStruct)
%MUTATE NEAT mutation function
%   Expected fields in mutationStruct:
%   - ProbAddNode: probability of adding a new node
%   - PobabilityAddConnection: probability of adding a new connection
%   - ProbabilityRecurrency: governs if a recurrent connection is allowed in add_connection_mutation
%     Note: this will only activate if the random connection is a recurrent one, otherwise the
%     connection is simply accepted. If no possible non-recurrent connections exist for the current
%     node genes, then for e.g. a probability of 0.1, 9 times out of 10 no connection is added.
%   - ProbabilityMutateWeight
%   - ProbabilityGeneReenabled: probability of a connection gene being reenabled in offspring
%     if it was inherited disabled.
%   - WeightCap: weights will be restricted from -mutationStruct.WeightCap to
%     mutationStruct.WeightCap
%   - WeightRange: random distribution with width mutationStruct.weight_range, centered on 0.
%     Mutation range of 5 will give random distribution from -2.5 to 2.5
    for i = 1:length(children)
        %% Hidden nodes culling - remove any hidden nodes where there is no
        % corresponding connection gene in the child
        nodeConnected = ones(1, size(children(i).NodeGenes, 2));
        for nodeIndex = 1:length(nodeConnected)
            if (children(i).NodeGenes(2, nodeIndex) ~= NEAT.NodeTypes.HIDDEN)
                continue;
            end
            nodeConnectedSum =...
                  sum(children(i).ConnectionGenes(2, :) == children(i).NodeGenes(1, nodeIndex))...
                + sum(children(i).ConnectionGenes(3, :) == children(i).NodeGenes(1, nodeIndex));
            nodeConnected(nodeIndex) = (nodeConnectedSum > 0);
        end
        children(i).NodeGenes = children(i).NodeGenes(:, nodeConnected);

        %% Disabled Genes Mutation
        % run through all connection genes in a new_individual, find disabled
        % connection genes, enable again with ProbabilityGeneReenabled probability
        disabledIndices = find(children(i).ConnectionGenes(5, :) == 0);
        reenabledIndices = disabledIndices(rand(1, size(disabledIndices, 2))...
                                           < mutationStruct.ProbabilityGeneReenabled);
        children(i).ConnectionGenes(5, reenabledIndices) = 1;

        %% Weight Mutation
        connectionGenes = children(i).ConnectionGenes;
        mutateWeightIndices = find(rand(1, size(children(i).ConnectionGenes, 2))...
                                   < mutationStruct.ProbabilityMutateWeight);
        % offset weights of mutated genes with (rand - 0.5)*WeightRange
        offset = mutationStruct.WeightRange * (rand(1, length(mutateWeightIndices)) - 0.5);
        connectionGenes(4, mutateWeightIndices) = connectionGenes(4, mutateWeightIndices) + offset;
        % limit weights with WeightCap
        exceedCapIndices = find(abs(connectionGenes(4, :)) > mutationStruct.WeightCap);
        connectionGenes(4, exceedCapIndices) = sign(connectionGenes(4, exceedCapIndices))...
                                               * mutationStruct.WeightCap;
        children(i).ConnectionGenes = connectionGenes;
    end

end

