% jssfigures recreates the figures in the paper. It's a stripped down
% version of jsstutorial.
%
% To get exactly the same figures as the paper, you must have jssdemo1 &
% jssdemo2.mat available. You also need an R installation to get the last
% figure.

%% load some prepared data for a logistic model, fit it, and plot the coefficients

load jssdemo1.mat
model = glm_logistic(y,X,'nointercept');
fit = penalized(model,@p_lasso);
figure
subplot(1,2,1)
plot_penalized(fit);
title('(A)')

% cross-validate 5 times and plot the result

cv = cv_penalized(model, @p_lasso, 'folds', 5); 
subplot(1,2,2)
plot_cv_penalized(cv);
title('(B)')
set(gcf,'pos',[331   246   897   420])
panels('left',0.075,'right',0.05')
set(gcf,'paperpositionmode','auto')
pause(0.1)
print -depsc fig1.eps

%% load some prepared data for a gaussian model and fit

load jssdemo2.mat

model2 = glm_gaussian(y,X); 

fit = penalized(model2, @p_clipso, 'alpha', 0.3);
figure
subplot(1,2,1)
plot_penalized(fit)
title('(A)')

% fit a range of alpha values for clipso

fit = penalized(model2,@p_clipso,'alpha', [inf,1,0.5,0.3,0.05] );
subplot(1,2,2)
plot_penalized(fit, 'slice', 5 )
title('(B)')
set(gcf,'pos',[331   246   897   420])
panels('left',0.075,'right',0.05')
set(gcf,'paperpositionmode','auto')
pause(0.1)
print -depsc fig2.eps

%% cross-validate to find the best lambda, alpha

cv = cv_penalized(model2,@p_clipso,'alpha',[inf,1,0.5,0.3,0.05], 'folds', 3);
figure
subplot(1,2,1)
plot_cv_penalized(cv)
a=axis;
%axis([a(1:2), 6000,9000])
title('(A)')

% plot the min penalty error and the lasso error on the same graph

subplot(1,2,2)
plot_cv_penalized(cv,'slice',[1,cv.minalpha],'errorbars','on')
title('(B)')
set(gcf,'pos',[331   246   897   420])
panels('left',0.075,'right',0.05')
set(gcf,'paperpositionmode','auto')
pause(0.1)
print -depsc fig3.eps

%% Compare R and penalized.
rpath = 'E:\Program Files\R\R-3.0.0\bin\R.exe';
if ~exist(rpath,'file')
    [fname, pathname] = uigetfile({'*.*'}, 'Find R executable (cancel if none)');
    if fname~=0
        rpath = [pathname,fname];
    else
        msgbox('Sorry, R is needed to generate Figure 4')
        return
    end
end
cmd = sprintf('"%s"  CMD BATCH figure4.R',rpath);
[status,result] = system(cmd);
fitR = load('jssfigure4out.mat');
fitR.intercept = [];
%%
load jssfigure4
model = glm_logistic([y(:,2),y(:,1)+y(:,2)],X,'nointercept');
fit = penalized(model,@p_lasso,'lambda',fitR.lambda,'forcelambda',true);
figure
subplot(1,2,1)
plot_penalized(fit); 
if exist('fitR','var')  
    hold on 
    plot_penalized(fitR,'symbol','.'); 
    hold off
end 
a = axis;
title('(A)')
subplot(1,2,2)
semilogx(fitR.lambda, fitR.beta'-fit.beta')
set(gca,'xdir','reverse')
xlabel('\lambda')
title('(B)') 
b = axis;
axis([a(1:2), b(3:4)]);
set(gcf,'pos',[331   246   897   420])
panels('left',0.075,'right',0.05')
set(gcf,'paperpositionmode','auto')
pause(0.1)
print -depsc fig4.eps

