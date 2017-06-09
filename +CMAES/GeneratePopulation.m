function GeneratePopulation(obj, populationSize, numGene, Constraints)
%GENERATEPOPULATION generate CMA-ES parameters and initialize population
%   following initialization from https://www.lri.fr/~hansen/purecmaes.m
%   meant to wotk with the GeneticEncoding.ValueEncoding class

    % Constant parameters calculated from mueff & numGene
    c1 = 2 / ((numGene + 1.3)^2 + Constraints.mueff);
    cmu = min(1 - c1,...
              2 * (Constraints.mueff - 2 + 1/Constraints.mueff) /...
              ((numGene + 2)^2 + Constraints.mueff));
    % Strategy parameter setting: Adaptation
    cc = (4 + Constraints.mueff/numGene) /...
        (numGene + 4 + 2*Constraints.mueff/numGene);% time constant for cumulation for C
    cs = (Constraints.mueff + 2) /...
        (numGene + Constraints.mueff + 5);          % t-const for cumulation for sigma control
    damps = 1 + 2*max(0, sqrt((Constraints.mueff - 1)/(numGene + 1)) - 1) + cs;
                                                    % damping for sigma 
                                                    % usually close to 1
    % Initialize dynamic parameters
    pc = zeros(numGene, 1); ps = zeros(numGene, 1); % evolution paths for C and sigma
    B = eye(numGene, numGene);                      % B stores eigenvectors
    D = ones(numGene, 1);                           % diagonal D stores eigenvalues
    C = B * diag(D.^2) * B';                        % covariance matrix C
    chiN = numGene^0.5 *...
        (1 - 1/(4*numGene) + 1/(21 * numGene^2));   % expectation of 
                                                    %   ||N(0,I)|| == norm(randn(N,1))  
    % store in obj.Constraints
    obj.Constraints.cmu = cmu;
    obj.Constraints.c1 = c1;
    obj.Constraints.cc = cc;
    obj.Constraints.cs = cs;
    obj.Constraints.damps = damps;
    obj.Constraints.pc = pc;
    obj.Constraints.ps = ps;
    obj.Constraints.eigenVectors = B;
    obj.Constraints.eigenValues = D;
    obj.Constraints.covariance = C;
    obj.Constraints.chiN = chiN;
    obj.Constraints.counteval = 0;
    obj.Constraints.sigma = obj.Constraints.initialSigma;

    mean = rand(1, numGene)';
    obj.Constraints.mean = mean;
    [population, invSqrtC] = CMAES.SamplePopulation(mean, obj.Constraints.sigma,...
                                                    obj.Constraints.covariance,...
                                                    populationSize);
    obj.Constraints.invsqrtC = invSqrtC;
    set(obj, 'Population', population);
end

