function [la, C, ObjConv] = BKM(X, c)

% Balanced k-means clustering algorithm
% Uses Hungarian algorithm in assignment phase
% Mikko Malinen
% University of Eastern Finland
% 2013


tic;

% data

%X =load('X:\clustering\datasets\iris.txt');  % 150 points, k=3, d=4
%X = load('X:\clustering\datasets\subsets\iris_subset_50.txt'); % 50 points, k=3, d= 4
%X = load('X:\clustering\datasets\subsets\thyroid_subset_50.txt'); % 50
%points , k= 2, d= 5
%X = load('X:\clustering\datasets\subsets\wine_subset_50.txt'); % 50
%points, k = 3, d = 13
%X = load('X:\clustering\datasets\subsets\breast_subset_50.txt'); % 50
%points, k= 2, d=9
%X = load('X:\clustering\datasets\subsets\s1_subset_150.txt');  % 150 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s2_subset_150.txt');  % 150 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s3_subset_150.txt');  % 150 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s4_subset_150.txt');  % 150 points, k=15, d=2
%
%X = load('X:\clustering\datasets\subsets\s1_subset_50.txt');  % 50 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s2_subset_50.txt');  % 50 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s3_subset_50.txt');  % 50 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s4_subset_50.txt');  % 50 points, k=15, d=2
% X = load('F:\MY RESEARCH\POJ_2016_IJCAI\code_5_6\code_others\Balanced k-means\s1_subset_500.txt');  % 500 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s2_subset_500.txt');  % 500 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s3_subset_500.txt');  % 500 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s4_subset_500.txt');  % 500 points, k=15, d=2
%X = load('X:\clustering\datasets\subsets\s1_subset_1000.txt');  % 1000 points, k=15, d=2
%X = X(1:200,:);
%X = load('X:\clustering\datasets\s2.txt');  % 5000 points, k=15, d=2
%X = load('X:\clustering\datasets\thyroid.txt'); % 5dim. 215 points 2 clust
%X = load('X:\clustering\datasets\wine.txt'); % 13 dim, 178 points, 3 clust

% rottavalikoitu.txt
%fid = fopen('rottavalikoitu.txt');
% n vectors in 14 dimensions, 1st dim is gender
%X = textscan(fid,'%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f,%f')
%fclose(fid);
%X = cell2mat(X);
%X

% normalizing rottavalikoitu.txt
%for i=1:size(X,2) % dimensions
%    X(:,i) = (X(:,i)-mean(X(:,i)))/std(X(:,i))
%end
    


% number of points
n = size(X,1);

% number of clusters
k = c;

% minimum size of a cluster

minimum_size_of_a_cluster = floor(n/k);


% dimensionality

d = size(X,2);

MSE_best = 0; % dummy value

number_of_iterations_distribution = zeros(100,1);

for repeats = 1:1      % 1:100

% initial centroids

for j = 1:k
pass = 0;
while pass == 0
    i = randi(n);
    pass = 1;
    for l = 1:j-1
       if X(i,:) == C(l,:) 
           pass = 0;
       end
    end
end
C(j,:) = X(i,:);
end


partition = 0;                 % dummy value
partition_previous = -1;       % dummy value
partition_changed = 1;

kmeans_iteration_number = 0;

while ((partition_changed)&&(kmeans_iteration_number<100))% kmeans iterations
    
partition_previous = partition;

% kmeans assignment step

% setting cost matrix for Hungarian algorithm
costMat = zeros(n);
for i=1:n
    for j = 1:n
        costMat(i,j) = (X(j,:)-C(mod(i,k)+1,:))*(X(j,:)-C(mod(i,k)+1,:))';
    end
end

% Execute Hungarian algorithm
[assignment,cost] = munkres(costMat);

% zero partitioning
for i = 1:n
    partition(i) = 0;
end

% find current partitioning from hungarian algorithm result
for i = 1:n 
    if assignment(i) ~= 0
            partition(assignment(i))=mod(i,k)+1;
    end
end

% kmeans update step

for j = 1:k
C(j,:) = mean(X(find(partition==j),:));
end


kmeans_iteration_number = kmeans_iteration_number +1;

partition_changed = sum(partition~=partition_previous);

end  % kmeans iterations


MSE = 0;
for i = 1:n
    MSE = MSE + ((X(i,:)-C(partition(i),:))*(X(i,:)-C(partition(i),:))')/n;
end

if (MSE<MSE_best)||(repeats==1)
    MSE_best = MSE;
    C_best = C;
    partition_best = partition;
end

MSE_repeats(repeats) = MSE;

number_of_iterations_distribution(kmeans_iteration_number) = number_of_iterations_distribution(kmeans_iteration_number)+1;

end % repeats
    

% new notation

C = C_best;
partition = partition_best;
MSE = MSE_best;

% number_of_iterations_distribution
% 
% MSE
% 
% mean_MSE_repeats = mean(MSE_repeats)
% std_MSE_repeats = std(MSE_repeats)

la = partition';
ObjConv = MSE;


end