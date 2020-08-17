function output = open_brackets(tokens)
    % tokens = 'a*(b+c)'';
    tokens = polish_postfix(tokens);
    result = java.util.Stack();
    ops = ['+', '-', '*', '/', '^'];

    for k = 1:length(tokens)
        x = tokens(k);
        % broken = {};
        % disp(result);
        if ismember(x, ops)
            a = result.pop();
            b = result.pop();
            if ~isnan(str2double(a)) && x == '/'
                a = string(1/str2double(a));
                temp = b; b = a; a = temp;
                x = '*';
            end
            if contains(a, '+') && ismember(x, ['*', '/'])
                broken = split(a, '+');
                % disp(broken)
                g = string(zeros(length(broken), 1));
                for n = 1:length(broken)
                    g(n) = strcat(b, x, broken(n));
                end
                result.push(join(g, '+'));
            else
                result.push(strcat(b, x, a));
            end
        else
            result.push(x);
        end
    end

output = result.pop();