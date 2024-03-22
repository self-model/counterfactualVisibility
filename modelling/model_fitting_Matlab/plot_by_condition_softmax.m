function plot_by_condition_softmax(params, data, dt, T)
    % Assuming get_model_predictions_ndt is a function that returns predictions
    % for high and low occlusion based on the parameters provided

    % %apply the sigmoid function to the thetas and gamma
    params(1:5) = 1./(1+exp(-10.*params(1:5)));

    %multiply temp by 10
    params(10) = params(10)*10;

    % %apply the exponent to alpha and temp
    params(8:10) =exp(params(8:10));

    % HIGH OCCLUSION
    predictions_high = get_model_predictions_softmax([params(1), params(2)+params(1)]*params(8), [params(3), params(4)+params(3)]*params(9), params(5), params(6), params(7), params(10), dt, T);
    figure;
    high_counts = squeeze(data(1,:,:,:));
    high_counts=high_counts/sum(high_counts(:));
    for i = 1:2
        for j = 1:2
            subplot(4, 1, (i-1)*2 + j);
            predictions_high=predictions_high/sum(predictions_high(:));
            plot(squeeze(predictions_high(i, j, :)));
            hold on; % Hold on to plot on the same axes

            % MATLAB does not directly support histogram weighting in the same way,
            % so you might need to manually weight the histogram or use bar plot.
            % For simplicity, here's an example using bar plot to mimic histogram:
            counts = squeeze(high_counts(i,j,:)); % Squeeze to remove singleton dimensions
            maxy=max(max(counts(:),max(predictions_high(:))));
            bar(1:T, counts, 'FaceAlpha', 0.5); % Using bar plot instead of histogram

            xlabel('Index');
            ylabel('Density Value');
            ylim([0,maxy])
            grid on;

            title(sprintf('Density and Count Data (%d, %d)', i-1, j-1));
            legend({'Density Data', 'Count Data'}, 'Location', 'NorthEast');
        end
    end
    sgtitle('High Occlusion'); % Super title for the figure

    % LOW OCCLUSION
    predictions_low = get_model_predictions_softmax([params(1), params(2)+params(1)]/params(8), [params(3), params(4)+params(3)]/params(9), params(5), params(6), params(7), params(10), dt, T);
    predictions_low=predictions_low/sum(predictions_low(:));
    low_counts = squeeze(data(2,:,:,:));
    low_counts = low_counts/sum(low_counts(:));
    figure;
    for i = 1:2
        for j = 1:2
            subplot(4, 1, (i-1)*2 + j);
            plot(squeeze(predictions_low(i, j, :)));
            hold on; % Hold on to plot on the same axes

            counts = squeeze(low_counts(i,j,:)); % Squeeze to remove singleton dimensions
            maxy=max(max(max(counts(:), max(predictions_low(:)))));
            bar(1:T, counts, 'FaceAlpha', 0.5); % Using bar plot instead of histogram

            xlabel('Index');
            ylabel('Density Value');
            ylim([0,maxy])
            grid on;

            title(sprintf('Density and Count Data (%d, %d)', i-1, j-1));
            legend({'Density Data', 'Count Data'}, 'Location', 'NorthEast');
        end
    end
    sgtitle('Low Occlusion'); % Super title for the figure
end
