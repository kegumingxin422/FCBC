fileNames = dir('data');
result = zeros(length(fileNames),5);
for i = 76: 78 %length(fileNames)
    dataName = fileNames(i).name;
    disp(dataName);
    load(strcat('data\',dataName));
    K = length(unique(new_gnd));
    t0 = cputime;
    index = BKM(new_fea, K);
    result(i,5) = cputime-t0;
    [VIn, VDn, Rn, NMI] = exMeasure(index,new_gnd);
    
    counts = hist(index,1:K);
    result(i,1) = Rn;
    result(i,2) = NMI;
    result(i,3) = std(counts)/mean(counts);
    temp = counts/sum(counts);
    result(i,4) = -1/(log(K)) * sum(temp.*log(temp));
    save('result_BKM.mat','result')
    disp(i);
end