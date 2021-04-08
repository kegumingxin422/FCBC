fileNames = dir('data');
result = zeros(length(fileNames),5);
for i = 3:length(fileNames)
    dataName = fileNames(i).name;
    disp(dataName);
    load(strcat('data\',dataName));
    K = length(unique(new_gnd));
    
    times = 10;
    temp_result = zeros(times,5);
    for t = 1 : times
        t0 = cputime;
        index = FBKmeans(new_fea, K, 100);
        temp_result(t,5) = cputime-t0;
        [VIn, VDn, Rn, NMI] = exMeasure(index,new_gnd);
        counts = hist(index,1:K);
        temp_result(i,1) = Rn;
        temp_result(i,2) = NMI;
        temp_result(i,3) = std(counts)/mean(counts);
        temp = counts/sum(counts);
        temp_result(i,4) = -1/(log(K)) * sum(temp.*log(temp));
    end
    
    result(i,:) = temp_result(find(temp_result(:,1) == max(temp_result(:,1)),1),:);
    save('result_BKM.mat','result')
    disp(i);
end