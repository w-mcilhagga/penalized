function [HL,df] = hosmer_lemeshow(model,beta,varargin)
% Implements the Hosmer-Lemeshow test.

% get values
[l,p] = logL(model,beta);
obs = model.glm_base.y;
n = model.n;
ncat = 10;
plotit = true;
for i=1:2:length(varargin)
    switch varargin{i}
        case 'groups'
            ncat = varargin{i+1};
        case 'plot'
            plotit = varargin{i+1};
    end
end

% sort by p
[p,idx] = sort(p);
obs = obs(idx);
n = n(idx);

% divide into ncat groups
HL = 0;
groupsize = length(p)/ncat;
O = zeros(ncat,1);
E = zeros(ncat,1);
N = zeros(ncat,1);
for i=0:ncat-1
    groupstart = round(i*groupsize)+1;
    groupend = min(length(p),round((i+1)*groupsize));
    group = groupstart:groupend;
    O(i+1) = sum(obs(group));
    E(i+1) = sum(p(group));
    N(i+1) = sum(n(group));
    pg = mean(p(group));
    HL = HL + (O(i+1)-E(i+1))^2/(N(i+1)*pg*(1-pg));
end
df = ncat-2;

if plotit
    plot(E./N,O./N,'-*')
    xlabel('Expected Proportion')
    ylabel('Observed Proportion')
    axis([0 1 0 1])
    axis equal
    axis square
end
