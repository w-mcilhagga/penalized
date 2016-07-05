%% This m-file replicates the instructions used in the tutorial section of the paper.

%% load some prepared data for a logistic model, fit it, and plot the coefficients

if ~exist('jssdemo1.mat')
    uiwait(warndlg('jssdemo1.mat is missing. Your results will not match those in the paper',...
        'Warning'))
    [y,X] = genmodel(1000,150,'logistic');
    save jssdemo1 y X
else
    load jssdemo1
end
model = glm_logistic(y,X,'nointercept');
fit = penalized(model,@p_lasso);
subplot(1,2,1)
set(gcf,'pos',[331   246   897   420])
plot_penalized(fit);  
title('Figure 1A')

%% cross-validate 5 times and plot the result

AIC = goodness_of_fit('aic', fit);
subplot(1,2,2)
semilogx(fit.lambda,AIC)
title('AIC plot, paused for 0.5 s')
pause(0.5)
cv = cv_penalized(model, @p_lasso, 'folds', 5);
plot_cv_penalized(cv); 
title('Figure 1B')

%% load some prepared data for a gaussian model and fit

if ~exist('jssdemo2.mat')
    uiwait(warndlg('jssdemo2.mat is missing. Your results will not match those in the paper',...
        'Warning'))
    [y,X] = genmodel(1000,150,'gaussian');
    save jssdemo2 y X
else
    load jssdemo2
end

model2 = glm_gaussian(y,X); 

fit = penalized(model2, @p_clipso, 'alpha', 0.3);
figure
subplot(1,2,1)
set(gcf,'pos',[341   256   897   420])
plot_penalized(fit)  
title('Figure 2A')

%% fit a range of alpha values for clipso

fit = penalized(model2,@p_clipso,'alpha', [inf,1,0.5,0.3,0.05] )
uiwait(msgbox('The next figure (which is not in the paper) pauses after every plot','plot_penalized','modal'))
pp=figure;
plot_penalized(fit)  % Interactive
close(pp)
subplot(1,2,2)
plot_penalized(fit,'slice', 5 ) 
title('Figure 2B')

%% cross-validate to find the best lambda, alpha

cv = cv_penalized(model2,@p_clipso,'alpha',[inf,1,0.5,0.3,0.05], 'folds', 3);
figure
subplot(1,2,1)
set(gcf,'pos',[351   266   897   420])
plot_cv_penalized(cv)
title('Figure 3A')

%% plot the min penalty error and the lasso error on the same graph
subplot(1,2,2)
plot_cv_penalized(cv,'slice',[1,cv.minalpha],'errorbars','on')
title('Figure 3B')
