function [new_fea, new_gnd] = getBalanceData(fea,gnd)
    K = length(unique(gnd));
    [~,m] = size(fea);
    counts = hist(gnd,1:K);
    num = min(counts);
    new_fea = zeros(num*K,m);
    for i = 1 : K
       temp = fea(gnd==i,:);
       index = randsample(size(temp,1),num);
       new_fea((i-1)*num+1:i*num,:) = temp(index,:);
    end
    new_gnd = reshape(repmat((1:K),num,1),[],1);
end