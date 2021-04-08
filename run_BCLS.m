fileNames = dir('data');
result = zeros(length(fileNames),5);
for i = [3:1:26 28:1:64 66:1:78]%length(fileNames)
    dataName = fileNames(i).name;
    disp(dataName);
    load(strcat('data\',dataName));
    K = length(unique(new_gnd));
    t0 = cputime;
    
    n = size(new_fea,1);
    index = kmeans(new_fea,K);
    label = eye(K);
    Y = label(index,:);
    index = BCLS_ALM(new_fea', Y, 10^(-4), 1000);
    result(i,5) = cputime-t0;
    [VIn, VDn, Rn, NMI] = exMeasure(index,new_gnd);
    
    counts = hist(index,1:K);
    result(i,1) = Rn;
    result(i,2) = NMI;
    result(i,3) = std(counts)/mean(counts);
    temp = counts/sum(counts)+eps;
    result(i,4) = -1/(log(K)) * sum(temp.*log(temp));
    save('result_BCLS.mat','result')
    disp(i);
end