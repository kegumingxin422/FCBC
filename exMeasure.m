function [VIn, VDn, Rn, NMI, labelnum, ncluster, cmatrix] = exMeasure(cluster,true_label)

[ cmatrix,labelnum,ncluster] = ConMatrixHard(cluster,true_label);

n = sum(sum(cmatrix));
pi = sum(cmatrix,2)/n;
pj = sum(cmatrix,1)/n;

%Variation of Information(normalized)
% VIn =1 + 2 * sum(sum((cmatrix/n) .* log2(cmatrix/n ./ (pi(:,ones(labelnum,1)).*pj(ones(ncluster,1),:)))))...
%     /(sum(pi.*log2(pi))+sum((pj).*log2(pj)));
VIn = cal_VIn(cmatrix,labelnum,ncluster,n,pi,pj);

%Van Dongen criterion(normalized)
VDn = (2*n - sum(max(cmatrix,[],1))-sum(max(cmatrix,[],2)))/(2*n - max(sum(cmatrix,2))-max(sum(cmatrix,1)));

%Rand statistic(normalized) 
Rn = cal_Rn(cmatrix,labelnum,ncluster,n,pi,pj);

%Normalized mutual information
NMI = cal_NMI(cmatrix,labelnum,ncluster,n,pi,pj);

end

function [ cmatrix,labelnum,ncluster] = ConMatrixHard(cluster,true_label)
%Obtain Contingency Matrix

%ncluster = size(cluster,2);
[label,temp,tagclu]= unique(cluster);
ncluster = size(label,1);

[tagcla,labelnum] = LableConvert( true_label );
cmatrix = zeros(ncluster,labelnum);%A ncluster-nclass contingency matrix

for i = 1: labelnum 
    claidx = tagcla==i;
    %index = find((claidx .* tagclu)>0);
    index = claidx .* tagclu;
    cmatrix(:,i) = histc(index,unique(tagclu));
    %     temp = unique(cluster(index));
    %     cmatrix(:,i) = histc(cluster(index),temp);
end

end

function [tag,labelnum] = LableConvert(true_label)
%Obatain Class labels

%rclass = importdata(true_label);
[label,A,tag]= unique(true_label);
labelnum = size(label,1);

end

function Rn = cal_Rn(cmatrix,labelnum,ncluster,n,pi,pj)
    
    temp = zeros(ncluster,labelnum);
    for i = 1 : ncluster
       for j = 1 : labelnum
          if  cmatrix(i,j)>1
              temp(i,j) = cmatrix(i,j)*(cmatrix(i,j)-1)/2;
          end
       end
    end
    
    tempi = zeros(size(pi,1),1);
    tempj = zeros(1,size(pj,2));
    for i = 1 : ncluster
       if pi(i)>0
           tempi(i) = pi(i)*n*(pi(i)*n-1)/2;
       end
    end
    for j = 1 : labelnum
       if pj(j)>0
           tempj(j) = pj(j)*n*(pj(j)*n-1)/2;
       end
    end
    
    m = sum(sum(temp));
    m1 = sum(sum(tempi,1));
    m2 = sum(sum(tempj,2));
    M = n*(n-1)/2;
    Rn = (m - m1*m2/M)/(m1/2+m2/2- m1*m2/M);
end

function VIn = cal_VIn(cmatrix,labelnum,ncluster,n,pi,pj)
   
    fenmu = 0;
    for i = 1 : ncluster
       if pi(i)>0
           fenmu = fenmu + pi(i)*log2(pi(i));
       end
    end
    for j = 1 : labelnum
       if pj(j)>0
           fenmu = fenmu + pj(j)*log2(pj(j));
       end
    end
    
     fenzi = 0;
     for i = 1 : ncluster
        for j = 1 : labelnum
           if cmatrix(i,j)>0
               fenzi = fenzi + (cmatrix(i,j)/n)*log2((cmatrix(i,j)/n)/pi(i)/pj(j));
           end
        end
     end
    
     VIn = 1 + 2*fenzi/fenmu;
end

function NMI = cal_NMI(cmatrix,labelnum,ncluster,n,pi,pj)
    
    fenzi = 0;
     for i = 1 : ncluster
        for j = 1 : labelnum
           if cmatrix(i,j)>0
               fenzi = fenzi + (cmatrix(i,j)/n)*log2((cmatrix(i,j)/n)/pi(i)/pj(j));
           end
        end
     end
     
     fenmu = sqrt(sum(pi.*log2(pi))*sum(pj.*log2(pj)));
     
     NMI = fenzi/fenmu;
end