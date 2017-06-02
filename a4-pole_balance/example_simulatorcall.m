%% This is an example call to the simulator
% 
targetFitness = 1000; % Time steps

% Set a fixed weight matrix (6 inputs, 2 hidden nodes, one output and a
% bias, so a 10x10 matrix)
wMat = (rand(10)-0.5);


% Call the simulator (without visualization)
reached_steps = twoPole_test( wMat, @RNNet, targetFitness);
% Call the simulator (with visualization)
reached_steps = twoPole_test( wMat, @RNNet, targetFitness,'vis');
