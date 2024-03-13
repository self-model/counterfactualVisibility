function plot_by_condition(params, data, T)
    % Assuming get_model_predictions_ndt is a function that returns predictions
    % for high and low occlusion based on the parameters provided.

    % HIGH OCCLUSION
    predictions_high = get_model_predictions_ndt(params(1:2).*exp(params(7)), params(3:4).*exp(params(8)), params(5), params(6), T);
    max_y=max(max(max(predictions_high)));
    figure;
    for i = 1:2
        for j = 1:2
            subplot(4, 1, (i-1)*2 + j);
            plot(30*squeeze(predictions_high(i, j, :)));
            hold on; % Hold on to plot on the same axes

            % MATLAB does not directly support histogram weighting in the same way,
            % so you might need to manually weight the histogram or use bar plot.
            % For simplicity, here's an example using bar plot to mimic histogram:
            counts = squeeze(data(1,i,j,:)); % Squeeze to remove singleton dimensions
            maxy=max(max(max(counts)));
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
    predictions_low = get_model_predictions_ndt(params(1:2), params(3:4), params(5), params(6), T);

    figure;
    for i = 1:2
        for j = 1:2
            subplot(4, 1, (i-1)*2 + j);
            plot(30*squeeze(predictions_low(i, j, :)));
            hold on; % Hold on to plot on the same axes

            counts = squeeze(data(2,i,j,:)); % Squeeze to remove singleton dimensions
            maxy=max(max(max(counts)));
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
