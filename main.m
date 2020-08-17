equations = get(m,'xEqtn');
pvalues = get(m,'Parameters');
xnames = get(m,'xList'); %- transition variables
xnames = string(xnames);
xdesc = get(m,'XDescript');
enames = get(m,'eList'); %- shocks
eq_num = length(equations);
source = zeros(eq_num,3);

i = 1;
for x = 1:eq_num
  equation = split(equations(x), '=');
  % names(x) = equation(1);
  [xnames, var_index] = find_var_index(xnames, equation(1));
  right = strrep(equation(2), ';', '');
  right = apply_mul(right{1});
  right = strrep(right, '!', ''); % hozircha minusni hisobga olmaymiz
  disp(right);
  for args = split(right, "+")
    disp(length(args));
    for r = 1:length(args)
      source(i, 1) = var_index;
      current = split(args{r}, '*');
      var_name = current{end};
      if contains(var_name, 'ss_') || ismember(var_name, enames) || contains(var_name, '{')
        continue
      else
        [xnames, source(i, 2)] = find_var_index(xnames, current{end});
        expression = 1;
        disp(args{r})
        for n = 1:(length(current) - 1)
          curr_item = current{n};
          if contains(curr_item, '(1-')
            curr_item=strrep(curr_item,'(1-','');
            curr_item=strrep(curr_item,')','');
            val = 1;
            params = split(curr_item,'-');
            for j = 1:length(params)
              val = val - pvalues.(params{j});
            end
            expression = expression * val;
          elseif isfield(pvalues, curr_item)
            expression = expression * pvalues.(curr_item);
          else
            expression = expression * str2double(curr_item);
          end
        end
        source(i, 3) = expression;
        i = i + 1;
      end
    end
  end
end

headers = {'source', 'target', 'value'};
links = array2table(source, 'VariableNames', headers);
nodes = array2table(transpose(xnames), 'VariableNames', {'name'});
jsonStr = jsonencode(containers.Map({'nodes','links'},{nodes,links}));
fid = fopen('mpafx6.json', 'w');
if fid == -1, error('Cannot create JSON file'); end
fwrite(fid, jsonStr, 'char');
fclose(fid);

