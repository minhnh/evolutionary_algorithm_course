function [population, invSqrtC] = SamplePopulation(mean, sigma, covariance,...
                                                   populationSize)
%SAMPLEPOPULATION sample a number of individuals around a normal distribution
    population = repmat(mean', populationSize, 1);
    numGene = length(mean);
    [B, D] = eig(covariance);   % eigen decomposition, B==normalized eigenvectors
    D = sqrt(diag(D));          % D is a vector of standard deviations now
    if ~isreal(D)
        D = real(D);
    end
    invSqrtC = B * diag(D .^ -1) * B';
    % sample from the normal distribution with given covariance
    parfor i = 1:populationSize
        population(i, :) = population(i, :) + sigma * (B * (D .* randn(numGene, 1)))';
    end
end

