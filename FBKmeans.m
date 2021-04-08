function [index, sumbest] = FBKmeans(data, K, lambda)
% K-means with balanced constraint
    [n,m] = size(data);
    maxIter =50; 
    %initialize the centroid
%     index = kmeans(data,K);
%     centroid = getCentroid(data, index, K, n, m);
    
    centroid = initialCentroid(data, K, n);
    size_cluster = ones(1,K);
    sumbest = inf;
    for i = 1 : maxIter
        D = getDistance(data, centroid, K, n, m, size_cluster, lambda);
        [d, idx] = min(D, [], 2); 
        totalsum = sum(d);
        if abs(sumbest - totalsum) < 1e-5
            break;           
        elseif totalsum < sumbest
            index = idx; 
            size_cluster = hist(index, 1:K);
            centroid = getCentroid(data, index, K, n, m);
            sumbest(i) = totalsum;
            disp(sumbest);
        else
            disp('objective function value increase!!!');
        end
    end
end

function centroid = initialCentroid(data, K, n)
    centroid = data(randsample(n,K),:);
end

function centroid = getCentroid(data, index, K, n, m)
    centroid = zeros(K,m);
    for k = 1 : K
       members = (index==k);
       if any(members)
          centroid(k,:) = sum(data(members,:))/sum(members);                     
       else
          centroid(k,:) = data(randsample(n,1),:);
       end
    end
end

function D = getDistance(data, centroid, K, n, m, size_cluster, lambda)
    D = zeros(n, K);
    for k = 1 : K
       D(:,k) = sum((data -  centroid(repmat(k,n,1),1:m)).^2,2) + lambda*size_cluster(k);
    end
end