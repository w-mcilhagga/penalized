function b = subsref(model,index)
% SUBSREF Define field name indexing for logistic objects

switch index(1).type
case '.'  % element
    try
        b = model.(index(1).subs);
    catch
        b = subsref(model.glm_base,index);
    end
end
