% Define the custom output function
function stop = outfun(x, optimValues, state)
    stop = false; % This function does not stop the algorithm
    switch state
        case 'iter'
            % During iterations, print the current parameter values
            disp(['Current Parameters: ', num2str(x)]);
    end
end

