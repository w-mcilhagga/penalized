% example of a number of different penalties applied to the same model.

fprintf('Gaussian model, six penalties, cross-validated\n')

[y,X,trueb] = genmodel(1000,15,'gaussian','rho',0.6,'snr',1,'decay',2,'scale',true);
model = glm_gaussian(y,X,'nointercept');
bb = [];

cv=cv_penalized(model,@p_lasso);
subplot(3,2,1)
plot_cv_penalized(cv);
title('lasso')
xlabel('')
%axis([0.0001  0.99 700 1000])
bb=[bb,cv.bestbeta];

cv=cv_penalized(model,@p_clipso,'alpha',0.5);
subplot(3,2,2)
plot_cv_penalized(cv)
title('clipso, \alpha=0.5')
xlabel('')
%axis([0.0001  0.99 700 1000])
bb=[bb,cv.bestbeta];

cv=cv_penalized(model,@p_clipso,'alpha',0.5,'scaled',true);
subplot(3,2,3)
plot_cv_penalized(cv)
title('scaled clipso, \alpha=0.5')
xlabel('')
%axis([0.0001  0.99 700 1000])
bb=[bb,cv.bestbeta];

cv=cv_penalized(model,@p_flash,'delta',0.7);
subplot(3,2,4)
plot_cv_penalized(cv)
title('flash, \delta=0.7')
xlabel('')
%axis([0.0001  0.99 700 1000])
bb=[bb,cv.bestbeta];

cv=cv_penalized(model,@p_concavePF,'k',0.3);
subplot(3,2,5)
plot_cv_penalized(cv)
title('concavePF, k=0.3')
%axis([0.0001  0.99 700 1000])
bb=[bb,cv.bestbeta];

b = cv.fit.beta(:,end);
cv=cv_penalized(model,@p_adaptive,'gamma',0.1,'adaptivewt',{abs(b)});
subplot(3,2,6)
plot_cv_penalized(cv)
title('adaptive, \gamma=0.1')
%axis([0.0001  0.99 700 1000])
bb=[bb,cv.bestbeta];

figure
plot(trueb,'.');
hold on
plot(bb)
n = bb-repmat(trueb,[1,6]);
title('True beta . vs other estimates')
legend('true','lasso','clipso','scaled clipso','flash','concavePF','adaptive')
sum(n.^2)
