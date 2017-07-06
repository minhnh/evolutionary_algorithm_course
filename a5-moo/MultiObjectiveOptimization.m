%% Solution for the MOO problem using NSGA-II
% Author:   Minh Nguyen & Pranjal Dohl
% Date:     2017-07-06
%%
clear;clc;clf;
POPULATION_SIZE = 100;
VERBOSE = false;
ELITISM = false;        % built into NSGA-II
NUM_ITERATION = 200;
NUM_TRIES = 20;
NUM_GENE = 32;          % number of bits in each genome
TARGET = NUM_GENE;      % target: sum of leading and trailing zeros = NUM_GENE

% setup objectives for NSGA-II
CONSTRAINTS.objectiveFunctions = {@GetLeadingZeros, @GetTrailingOnes};
CONSTRAINTS.objectiveNames = {'numLeadingZeros', 'numTrailingOnes'};
% setup funtion to randomly generate a single genome, to be called in
% NSGAII.GeneratePopulation
CONSTRAINTS.getGenome = @GetGenome;
% setup crossover and mutation parameters, use single point crossover for binary genomes
CROSSOVER_PARAMS.funcSingleCrossover = @GeneticEncoding.BinaryOperators.CrossoverSinglePoint;
CROSSOVER_PARAMS.Rate = 0.05;
MUTATION_RATE = 0.01;

ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                   @NSGAII.GeneratePopulation, @GetFitness,...
                                   @NSGAII.SelectWinners, @Crossover, @Mutate, @CheckConvergence,...
                                   VERBOSE);
% setup visualization
fig = figure(1);
axis([0 NUM_GENE 0 NUM_GENE]);
Visualization.gif('front_evolution.gif', 'frame', fig, 'DelayTime', 0.5);
Visualization.SetupPlot('Front evolutions', 'Number of leading zeros', 'number of trailing ones', 24, []);

% iterate the algorithm
fitnessInit = GetFitness(ie.Population, TARGET, ie.Constraints);
ie.Iterate(NUM_ITERATION, ELITISM, CROSSOVER_PARAMS, MUTATION_RATE);
fitnessFinal = GetFitness(ie.Population, TARGET, ie.Constraints);

%% Pole balancing specific functions
function genome = GetGenome(numGene)
genome = randi([0, 1], 1, numGene);
end

function numLeadingZeros = GetLeadingZeros(genome)
firstOnePos = find(genome, 1, 'first');
if isempty(firstOnePos)
    numLeadingZeros = length(genome);
else
    numLeadingZeros = firstOnePos - 1;
end
end

function numTrailingOnes = GetTrailingOnes(genome)
lastZeroPos = find(~genome, 1, 'last');
if isempty(lastZeroPos)
    numTrailingOnes = 16;
else
    numTrailingOnes = length(genome) - lastZeroPos;
end
end

function converging = CheckConvergence(~)
converging = false;
end