function children = Crossover(obj, parents, ~)
%CROSSOVER create new mean using the calculated weights
%   Sum of weights must be 1.0
%   assuming sorted parents from SelectWinners
    numGenome = size(parents, 1);
    mu_ = length(obj.Constraints.weights);
    ps = obj.Constraints.ps;
    if all(abs(ps(:)) < 1e-10)
        disp('');
    end
    mean = parents(1:mu_, :)' * obj.Constraints.weights;
    children = repmat(mean', numGenome, 1);
end