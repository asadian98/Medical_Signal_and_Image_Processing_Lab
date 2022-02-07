function [Clusters] = Kmeans(inputData, num_Clusters, initialMeans)

    [~, columns] = size(inputData);
    Clusters = zeros(1, columns);
    newMeans = initialMeans;
    means = newMeans + 1;
    
    while(newMeans ~= means)
        means = newMeans;
        
        % Find winner for each data
        for i = 1:columns
            dmin = 1000;
            winner = 1;
            for j = 1:num_Clusters
                d = sqrt(sum((inputData(:, i) - means(:, j)) .^ 2)); 
                if(d < dmin)
                    winner = j;
                    dmin = d;
                end
            end
            Clusters(i) = winner;
        end

        % Calculate & update new means
        sumMeans = zeros(3, num_Clusters);
        numClus = zeros(1, num_Clusters);
        for i = 1:columns
            sumMeans(:, Clusters(:, i)) = sumMeans(:, Clusters(:, i)) + inputData(:, i);
            numClus(Clusters(:, i)) = numClus(Clusters(:, i)) + 1;
        end
        for i = 1:num_Clusters
            newMeans(:, i) = mean(sumMeans(:, i)) / numClus(i);
        end
    end
end

