%% Solution for the MOO problem using NSGA-II
% Author:   Minh Nguyen
% Date:     2017-06-01
%%
clear;clc;clf;
POPULATION_SIZE = 50;
VERBOSE = false;
ELITISM = false;        %TODO:?
NUM_ITERATION = 100;
NUM_TRIES = 20;
NUM_GENE = 16;          % dependent on network topology
TARGET = NUM_GENE;          % target: simulation runs for 1000 time steps

CONSTRAINTS.objectiveFunctions = {@GetLeadingZeros, @GetTrailingOnes};
CONSTRAINTS.objectiveNames = {'numLeadingZeros', 'numTrailingOnes'};
CONSTRAINTS.getGenome = @GetGenome;

CROSSOVER_PARAMS.funcSingleCrossover = @GeneticEncoding.BinaryOperators.CrossoverSinglePoint;
CROSSOVER_PARAMS.Rate = 0.05;
MUTATION_RATE = 0.01;
ie = GeneticEncoding.ValueEncoding(POPULATION_SIZE, NUM_GENE, TARGET, CONSTRAINTS,...
                                   @NSGAII.GeneratePopulation, @GetFitness,...
                                   @SelectWinners, @Crossover, @Mutate, @CheckConvergence,...
                                   VERBOSE);
fig = figure(1);
axis([0 NUM_GENE 0 NUM_GENE]);
Visualization.gif('front_evolution.gif', 'frame', fig, 'DelayTime', 0.2);
Visualization.SetupPlot('Front evolutions', 'Number of leading zeros', 'number of trailing ones', 24, []);

% set(gcf, 'position', [0 0 1.5 1.5]);
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