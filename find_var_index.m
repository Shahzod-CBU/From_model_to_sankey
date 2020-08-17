function [xnames, var_index] = find_var_index(xnames, var_name)
    if ismember(var_name, xnames)
        var_index = find(xnames == var_name) - 1;
    else
        var_index = length(xnames);
        xnames(var_index + 1) = var_name;
    end