function b = sample(model,index)
% SAMPLE returns a sample of the observations in the model 
% It does not restandardize or recentre the columns, because the estimated
% beta from the sampled model is used on another sample.

% retrieve the original data
p = property(model);

% create a new model
b = glm_base(model.y(index), model.X(index,:), 'nointercept');

% copy over needed properties
b.intercept = p.intercept;
b.colscale = p.colscale;


