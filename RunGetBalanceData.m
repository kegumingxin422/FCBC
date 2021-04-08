fileNames = dir('data-original');

for i = 3: length(fileNames)
   dataName = fileNames(i).name;
   load(strcat('data-original\',dataName));
   [new_fea, new_gnd] = getBalanceData(fea,gnd);
   save(strcat('data\b_',dataName),'new_fea','new_gnd');
   disp(i);
end