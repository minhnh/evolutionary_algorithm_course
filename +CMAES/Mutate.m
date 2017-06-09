function children = Mutate(obj, children, ~)
%MUTATE Perform covariance and step size update
%   - expecting a repetition of new mean as children
%   - follow https://www.lri.fr/~hansen/purecmaes.m implementation
%   - meant to work with GeneticEncoding.ValueEncoding
    newMean = children(1, :)';
    numGenome = size(children, 1);
    numGene = size(children, 2);
    mu_ = length(obj.Constraints.weights);
    cmu = obj.Constraints.cmu;
    sigma = obj.Constraints.sigma;
    cs = obj.Constraints.cs;
    cc = obj.Constraints.cc;
    c1 = obj.Constraints.c1;

    % Cumulation: Update evolution paths
    obj.Constraints.counteval = obj.Constraints.counteval + numGenome;
    ps = (1 - cs) * obj.Constraints.ps ... 
          + sqrt(cs * (2 - cs) * obj.Constraints.mueff) *...
            obj.Constraints.invsqrtC * (newMean - obj.Constraints.mean) / sigma;
    hsig = sum(ps.^2)...
                / (1 - (1 - cs)^(2 * obj.Constraints.counteval / numGenome))...
                / numGene...
           < 2 + 4/(numGene + 1);                       % constraint on size of ps
                                                        % (unexplained in purecmaes.m)
    pc = (1 - cc) * obj.Constraints.pc ...
          + (1 - hsig) * sqrt(cc * (2 - cc) * obj.Constraints.mueff) *...
            (newMean - obj.Constraints.mean) / sigma;   % skip 2nd part if hsig is true

    % rule mu update
    temp = (1 / sigma) * (children(1:mu_, :) - repmat(obj.Constraints.mean', mu_, 1));
    newCovariance =...
        (1 - c1 - cmu) * obj.Constraints.covariance...  % regard old matrix  
        + c1 * (pc * pc') ...                           % plus rank one update
        + cmu * temp' * diag(obj.Constraints.weights) * temp;
    newCovariance = triu(newCovariance) + triu(newCovariance, 1)';   % enforce symmetry
    % sample new children
    [children, ~] = CMAES.SamplePopulation(newMean, sigma, newCovariance, numGenome);
    % Adapt step size sigma
    sigma = sigma * exp((cs/obj.Constraints.damps) *...
                        (norm(ps)/obj.Constraints.chiN - 1)); 
    % save parameters
    obj.Constraints.mean = newMean;
    obj.Constraints.covariance = newCovariance;
    obj.Constraints.sigma = sigma;
    obj.Constraints.ps = ps;
    obj.Constraints.pc = pc;
end