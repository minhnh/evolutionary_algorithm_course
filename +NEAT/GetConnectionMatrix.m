function connectionMatrix = GetConnectionMatrix( connectionGene, numNodes )
%GETCONNECTIONMATRIX Construct connection matrix from connection genes
%   expect connectionGene to be an array of dimension 5 rows * number of connections:
%   - row 1: innovation number
%   - row 2: connection from
%   - row 3: connection to
%   - row 4: weight
%   - row 5: enable bit
    connectionMatrix = zeros(numNodes);
    idx = sub2ind(size(connectionMatrix),...
                  connectionGene(3, :),...      % TO connections as rows
                  connectionGene(2, :));        % FROM connections as columns
    weights = connectionGene(4, :);
    weights(~connectionGene(5, :)) = 0;
    connectionMatrix(idx) = weights;
end

