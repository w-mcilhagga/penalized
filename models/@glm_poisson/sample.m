function b = sample(model,index)
% SAMPLE returns a sample of the observations of the model 

b = model;
b.glm_base = sample(b.glm_base,index);

