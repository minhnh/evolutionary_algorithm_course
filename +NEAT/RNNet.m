%% RNNet - Returns activation of all nodes in an RNN after one time step
%
% function a = RNNet (wMat, aMat, input, activation, p)
%
% Given a weight matrix, corresponding activation functions, initial
% input vector, and current node activations, returns activation of all
% nodes after propagating signal ONE TIMESTEP through an RNN.
%

function [a] = RNNet (wMat, input, activation)

    activation(1) = 1; % bias
    activation(2:length(input)+1) = input; % input state

    %% HINTS
    % Propagate signal through network one timestep    

    % Remember that in this case, the last value is the (only) output value
    a = activation*wMat;  % (so the output is a(end))

end
