function output = polish_postfix(tokens)
    % tokens = 'g1*RS+g3*(RSNEUTRAL+g2*(D4L_CPI{>4}+D4L_CPI_TAR{>4})+g4*L_GDP_GAP)/4+ju*SHK_RS/5+testing';
    my_stack = java.util.Stack();
    postfix = java.util.Stack();
    ops = ['+', '-', '*', '/', '^'];
    prec = containers.Map({'+', '-', '*', '/', '^'}, {0, 0, 1, 1, 2});
    opening = '('; 
    closing =  ')';
    chars = ['+', '-', '*', '/', '^', '(', ')'];
    var_name = '';
    for x = tokens
        if ismember(x, chars) && ~isempty(var_name)
            postfix.push(var_name);
            var_name = '';
        end
        if ismember(x, ops)
            while (~my_stack.empty() && ismember(my_stack.peek(), ops) ... 
                    && prec(my_stack.peek()) >= prec(x))
                postfix.push(my_stack.pop());
            end
            my_stack.push(x);
        elseif x == opening
            my_stack.push(x);
        elseif x == closing
            while ~my_stack.empty() && my_stack.peek() ~= opening
                postfix.push(my_stack.pop());
            end
            my_stack.pop();
        else
            var_name = strcat(var_name, x);
        end
    end
    if ~isempty(var_name)
        postfix.push(var_name);
    end
    while ~my_stack.empty()
        postfix.push(my_stack.pop());
    end

    output = postfix.toArray();