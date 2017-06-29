function GeneratePopulation(obj, populationSize, ~, constraints)
%GeneratePopulation Generate NN genomes with node and connection genes
%   Expected field in Constraints:
%   - InputDim: problem input dimension, number of input neurons
%   - OutputDim: problem output dimension, number of output neurons
%   NodeGenes is an array of dimension 2 rows * (InputDim + OutputDim + 1(bias)):
%   - row 1: node ID
%   - row 2: node type
%   ConnectionGenes is an array of dimension 5 rows * number of connections:
%   - row 1: innovation number
%   - row 2: connection from
%   - row 3: connection to
%   - row 4: weight
%   - row 5: enable bit
%   InnovationRecord is an array of dimension 5 rows * number of innovations,
%   to be stored in Constraint struct:
%   - row 1: innovation number
%   - row 2: node where the connection is from
%   - row 3: node where the connection is to
%   - row 4: ID of new node when it's created (2 new innovations expected after
%     a column with row 4 filled). For the initial population this value is the
%     highest node ID stored in the last column as reference to create new node
%     ID's.
%   - row 5: generation where this innovation occured
%   InnovationRecordDict is a dictionary for fast lookup of innovations
%   - key: sprintf('%d %d %d', [connection_from, connection_to, generation])
%   - value: column index in InnovationRecord
    numNode = constraints.InputDim + constraints.OutputDim + 1;
    nodeTypeRow = [NEAT.NodeTypes.INPUT * ones(1, constraints.InputDim, 'uint8'),...
                   NEAT.NodeTypes.BIAS * 1,...
                   NEAT.NodeTypes.OUTPUT * ones(1, constraints.OutputDim, 'uint8')];
    % generate random number of connections for each individual, minimum half
    % of inputs are connected
    numConnectionsMin = max(1, int32(constraints.InputDim / 2));
    numConnectionsList = randi([numConnectionsMin, constraints.InputDim],...
                               populationSize, 1);
    baseGenome = struct('NodeGenes', [1:numNode; nodeTypeRow],...
                        'ConnectionGenes', zeros(5, max(numConnectionsList)));
    population = repmat(baseGenome, populationSize, 1);
    innovationRecordDict = containers.Map();

    for i = 1:populationSize
        connectedInputs = randperm(constraints.InputDim, numConnectionsList(i));
        numConnections = (length(connectedInputs) + 1) * constraints.OutputDim;

        vectorConnectionFrom=rep([connectedInputs, constraints.InputDim + 1],...
                                 [1 constraints.OutputDim]);
        vectorConnectionTo = zeros(1, size(vectorConnectionFrom, 2));
        for j = 1:constraints.OutputDim
            startIndex = (j - 1)*(numConnectionsList(i) + 1) + 1;
            outputNodeId = constraints.InputDim + 1 + j;
            vectorConnectionTo(startIndex:startIndex + numConnectionsList(i))...
                    = outputNodeId*ones(1, numConnectionsList(i) + 1);
        end
        connectionMatrix=[vectorConnectionFrom;
                          vectorConnectionTo];
        innovationNumbers = zeros(1, numConnections);
        for connectionIndex = 1:size(connectionMatrix, 2)
            % keys are (from node ID, to node ID, generation (0 for initial)),
            % value is innovation number & column in the 
            innovationKey = sprintf('%d %d %d',...
                                    [connectionMatrix(:, connectionIndex)', 0]);
            if ~isKey(innovationRecordDict, innovationKey)
                innovationRecordDict(innovationKey) = innovationRecordDict.Count + 1;
            end
            innovationNumbers(connectionIndex) = innovationRecordDict(innovationKey);
        end
        population(i).ConnectionGenes = [innovationNumbers;
                                         connectionMatrix;
                                         rand(1, numConnections) * 2 - 1;
                                         ones(1, numConnections)];
    end
    innovationRecord = [1:innovationRecordDict.Count;
                        zeros(4, innovationRecordDict.Count)];
    for innovationKeyCell = innovationRecordDict.keys
        innovationKey = innovationKeyCell{1};
        innovationNumber = innovationRecordDict(innovationKey);
        innovationRecord([2 3 5], innovationNumber) = sscanf(innovationKey,...
                                                             '%d', [1 3]);
    end
    innovationRecord(4, size(innovationRecord, 2)) = numNode; %highest node ID for initial population
    constraints.InnovationRecordDict = innovationRecordDict;
    constraints.InnovationRecord = innovationRecord;
    set(obj, 'Population', population);
    set(obj, 'Constraints', constraints)
end

