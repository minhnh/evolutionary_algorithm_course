%% Solution for the function minimization problem using CMA-ES
% Author:   Minh Nguyen
% Date:     2017-06-01
%%
clear;clc;
POPULATION_SIZE = 150;
VERBOSE = false;
ELITISM = false;        %TODO:?
NUM_ITERATION = 100;
NUM_TRIES = 20;
NUM_GENE = -1;          % dependent on network topology
TARGET = 1000;          % target: simulation runs for 1000 time steps

CONSTRAINTS = struct('InputDim', 6,...
                     'OutputDim', 1,...
                     'NetworkFunction', @NEAT.RNNet);

MUTATION = struct();
MUTATION.ProbAddNode = 0.03;
MUTATION.PobabilityAddConnection = 0.05;
% governs if a recurrent connection is allowed in add_connection_mutation
%   Note: this will only activate if the random connection is a recurrent one,
%   otherwise the connection is simply accepted. If no possible non-recurrent
%   connections exist for the current node genes, i.e. for a probability of 0.1,
%   9 times out of 10 no connection is added.
MUTATION.ProbabilityRecurrency = 0.0;
% Probability of a connection gene being reenabled in offspring
%   if it was inherited disabled 
MUTATION.ProbabilityGeneReenabled = 0.25;
MUTATION.ProbabilityMutateWeight = 0.9;
% weights will be restricted from -mutation.weight_cap to mutation.weight_cap
MUTATION.WeightCap = 8;
% random distribution with width mutation.weight_range, centered on 0.
%   mutation range of 5 will give random distribution from -2.5 to 2.5
MUTATION.WeightRange = 5;

ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                   @NEAT.GeneratePopulation, @GetFitness,...
                                   @NEAT.SelectWinners, @NEAT.Crossover,...
                                   @NEAT.Mutate, @CheckConvergence,...
                                   VERBOSE);

fitnessInit = GetFitness(ie.Population, TARGET, ie.Constraints);
ie.Iterate(NUM_ITERATION, ELITISM, 0.1, MUTATION);
fitnessFinal = GetFitness(ie.Population, TARGET, ie.Constraints);

%% Pole balancing specific functions
function converging = CheckConvergence(~)
    converging = false;
end