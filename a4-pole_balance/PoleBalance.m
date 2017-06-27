%% Solution for the function minimization problem using CMA-ES
% Author:   Minh Nguyen
% Date:     2017-06-01
%%
clear;clc;
POPULATION_SIZE = 150;
VERBOSE = false;
ELITISM = false;        %TODO:?
NUM_ITERATION = 200;
NUM_TRIES = 20;
NUM_GENE = -1;          % dependent on network topology
TARGET = 1000;          % target: simulation runs for 1000 time steps

CONSTRAINTS = struct('InputDim', 6,...
                     'OutputDim', 1,...
                     'NetworkFunction', @NEAT.RNNet);

ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                   @NEAT.GeneratePopulation, @GetFitness,...
                                   @NEAT.SelectWinners, @NEAT.Crossover,...
                                   @NEAT.Mutate, @CheckConvergence,...
                                   VERBOSE);

function converging = CheckConvergence(~)
    converging = false;
end