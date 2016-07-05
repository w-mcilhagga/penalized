% example of a number of different penalties applied to the same model.

fprintf('Gaussian model, nine penalties\n')

[y,X,trueb] = genmodel(1000,100,'gaussian','rho',0.6,'snr',3,'decay',2,'scale',true);
model = glm_gaussian(y,X,'nointercept');

t = 0;
tic
fit=penalized(model,@p_lasso);
t=t+toc;
subplot(3,3,1)
plot_penalized(fit);
title('lasso')
xlabel('')

tic
fit=penalized(model,@p_clipso,'alpha',0.5);
t=t+toc;
subplot(3,3,2)
plot_penalized(fit)
title('clipso, \alpha=0.5')
xlabel('')

tic
fit=penalized(model,@p_clipso,'alpha',0.5,'scaled',true);
t=t+toc;
subplot(3,3,3)
plot_penalized(fit)
title('scaled clipso, \alpha=0.5')
xlabel('')

tic
fit=penalized(model,@p_flash,'delta',0.7);
t=t+toc;
subplot(3,3,4)
plot_penalized(fit)
title('flash, \delta=0.7')
xlabel('')

tic
fit=penalized(model,@p_concavePF,'k',0.3);
t=t+toc;
subplot(3,3,5)
plot_penalized(fit)
title('concavePF, k=0.3')

b = fit.beta(:,end);
tic
fit=penalized(model,@p_adaptive,'gamma',1,'adaptivewt',{abs(b)});
t=t+toc;
subplot(3,3,6)
plot_penalized(fit)
title('adaptive, \gamma=1')

tic
fit=penalized(model,@p_elastic,'alpha',0.5);
t=t+toc;
subplot(3,3,7)
plot_penalized(fit)
title('elastic \alpha=0.3')

tic
fit=penalized(model,@p_mcplus,'w',0.5);
t=t+toc;
subplot(3,3,8)
plot_penalized(fit)
title('MC+ w=0.3')

tic
fit=penalized(model,@p_Lq,'q',[1 0.75 0.5 0.25]);
t=t+toc;
subplot(3,3,9)
plot_penalized(fit,'slice',4)
title('Lq q=0.25, warm start from lasso')


t