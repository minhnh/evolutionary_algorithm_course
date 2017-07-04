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

CONSTRAINTS.objectiveFunctions = {@GetLeadingZeros, @GetTrailingOnes};
CONSTRAINTS.objectiveNames = {'numLeadingZeros', 'numTrailingOnes'};
CONSTRAINTS.getGenome = @GetGenome;

CROSSOVER_PARAMS.funcSingleCrossover = @GeneticEncoding.BinaryOperators.CrossoverSinglePoint;
CROSSOVER_PARAMS.Rate = 0.05;
MUTATION_RATE = 0.05;
% i.e: MUTATION.ProbabilityAddNode = 0.03;
ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                   @NSGAII.GeneratePopulation, @GetFitness,...
                                   @SelectWinners, @Crossover, @Mutate, @CheckConvergence,...
                                   VERBOSE);

fitnessInit = GetFitness(ie.Population, TARGET, ie.Constraints);
ie.Iterate(NUM_ITERATION, ELITISM, CROSSOVER_PARAMS, MUTATION_RATE);
fitnessFinal = GetFitness(ie.Population, TARGET, ie.Constraints);

%% Pole balancing specific functions
function genome = GetGenome(numGene)
genome = randi([0, 1], 1, numGene);
end

function numLeadingZeros = GetLeadingZeros(genome)
numLeadingZeros = find(genome, 1, 'first') - 1;
end

function numTrailingOnes = GetTrailingOnes(genome)
numTrailingOnes = length(genome) - find(~genome, 1, 'last');
end

function converging = CheckConvergence(~)
converging = false;
end