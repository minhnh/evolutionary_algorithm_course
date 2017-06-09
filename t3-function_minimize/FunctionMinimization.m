%% Solution for the function minimization problem using CMA-ES
% Author:   Minh Nguyen
% Date:     2017-06-01
%%
clear;clc;
POPULATION_SIZE = 15;
VERBOSE = false;
ELITISM = false; % built into weighted mean
NUM_ITERATION = 150;
NUM_TRIES = 20;

%% Common CMA-ES parameters
mu_ = POPULATION_SIZE / 2;
weights = mu_ + 1 - (1:mu_)';
%weights = log(mu_ + 1/2) - log(1:mu_)'; % wikipedia weight ratio
weights = weights / sum(weights);
mueff = 1 / sum(weights .^ 2);
disp(['mu: ' num2str(mu_)]);
disp(['weights: ' mat2str(weights)]);
disp(['mueff: ' num2str(mueff)]);

%% 2D frosen
dimensions = [2, 12, 2, 12];
functions = {@frosen, @frosen, @frastrigin, @frastrigin};
varNames = [];
bestFitnessAllTriesStruct = struct();
medianBestFitnessStruct = struct();
bestChildScruct = struct();
bestChildrenStruct = struct();

for i=1:length(dimensions)
    NUM_GENE = dimensions(i);
    TARGET = functions{i};
    varName = [func2str(TARGET) num2str(NUM_GENE) 'D' ];
    disp(['Problem: ' varName]);
    CONSTRAINTS = struct('weights', weights,...
                         'mueff', mueff,...
                         'initialSigma', 0.5);
    % Initialize population
    ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                      @CMAES.GeneratePopulation, @GetFitness,...
                                      @CMAES.SelectWinners, @CMAES.Crossover,...
                                      @CMAES.Mutate, @CheckConvergence,...
                                      VERBOSE);
    % start timer
    tic
    bestFitnessAllTries = zeros(NUM_TRIES, NUM_ITERATION + 1);
    bestChildren = zeros(NUM_TRIES, NUM_GENE);
    parfor k = 1:NUM_TRIES
        ie.funcInitPopulation(ie, POPULATION_SIZE, NUM_GENE, CONSTRAINTS);
        population = ie.Population;
        [bestFitness, ~, ~] = ie.Iterate(NUM_ITERATION, ELITISM, -1, -1);
        bestFitnessAllTries(k, :) = bestFitness;
        bestChildren(k, :) = ie.GetBestChild();
    end
    medianBestFitness = median(bestFitnessAllTries, 1);
    [~, argMax] = max(GetFitness(bestChildren, TARGET, CONSTRAINTS));
    bestChild = bestChildren(argMax, :);

    % time
    toc
    % save data
    bestFitnessAllTriesStruct.(varName) = bestFitnessAllTries;
    medianBestFitnessStruct.(varName) = medianBestFitness;
    bestChildStruct.(varName) = bestChild;
    bestChildrenStruct.(varName) = bestChildren;
    fig = figure(i);
    subplot(1, 2, 1), plot(medianBestFitness);
    Visualization.SetupPlot({['Median fitness over ' num2str(NUM_TRIES) ' runs of '],...
                             [num2str(NUM_ITERATION) ' iterations - ' varName]},...
                            'Iteration number', 'Fitness (negative value)', 20, [])
    subplot(1, 2, 2), boxplot(GetFitness(bestChildren, TARGET, -1));
    Visualization.SetupPlot({['Children with best fitness over ' num2str(NUM_TRIES) ' runs'],...
                             ['of ' num2str(NUM_ITERATION) ' iterations - ' varName]},...
                            '', 'Fitness (negative value)', 20, []);
    Visualization.save_figure(fig, ['t3-funcMin-fitnessandbox-' varName], 20);
    disp(['Bestchild fitness ' varName ': ' num2str(GetFitness(bestChild, TARGET, -1))]);
end

save('./median_fitness.mat',...
     'bestFitnessAllTriesStruct', 'medianBestFitnessStruct',...
     'bestChildStruct', 'bestChildrenStruct');


%% Functions specific to Shape Matching problem
function converging = CheckConvergence(obj)
    converging = false;
%     if cond(obj.Constraints.covariance) > 1e14
%         converging = true;
%     end
end