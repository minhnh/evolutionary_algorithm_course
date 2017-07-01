%% Solution for the MOO problem using NSGA-II
% Author:   Minh Nguyen
% Date:     2017-06-01
%%
clear;clc;
POPULATION_SIZE = 150;
VERBOSE = false;
ELITISM = false;        %TODO:?
NUM_ITERATION = 50;
NUM_TRIES = 20;
NUM_GENE = 16;          % dependent on network topology
TARGET = 1000;          % target: simulation runs for 1000 time steps

CONSTRAINTS = struct('InputDim', 6,...
                     'OutputDim', 1,...
                     'NetworkFunction', @NEAT.RNNet);

MUTATION = struct();
% i.e: MUTATION.ProbabilityAddNode = 0.03;
ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                   @NSGAII.GeneratePopulation, @GetFitness,...
                                   @SelectWinners, @NSGAII.Crossover,...
                                   @NSGAII.Mutate, @CheckConvergence,...
                                   VERBOSE);

fitnessInit = GetFitness(ie.Population, TARGET, ie.Constraints);
ie.Iterate(NUM_ITERATION, ELITISM, 0.1, MUTATION);
fitnessFinal = GetFitness(ie.Population, TARGET, ie.Constraints);

%% Pole balancing specific functions
function converging = CheckConvergence(~)
    converging = false;
end