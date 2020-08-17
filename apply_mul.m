function output = apply_mul(my_input)
    % my_input = 'g1*RS{-1}+(1-g1)*(RSNEUTRAL+g2*(D4L_CPI{+4}-D4L_CPI_TAR{+4})+g3*L_GDP_GAP)+(1-rho_smth)*SHK_RS+shk';
    my_input = strrep(my_input, '{+', '{>');
    my_input = strrep(my_input, '{-', '{<');

    %% replacing (1-var)'s with temp names
    names = java.util.Stack();
    values_arr = java.util.Stack();
    n = 1;
    while contains(my_input, '(1-')
        st_qavs_arr = strfind(my_input,'(1-');
        st_qavs = st_qavs_arr(1);
        fin_qavs = strfind(my_input,')');
        fr_qavs = fin_qavs(fin_qavs>st_qavs);
        name = strcat('temp', string(n));
        names.push(name);
        value = my_input(st_qavs:fr_qavs);
        values_arr.push(value);
        my_input = replace(my_input, value, name);
        n = n + 1;
    end
    
    if my_input(1) == '-', my_input(1) = '!'; end
    my_input = strrep(my_input, '-(', '+!1*(');
    my_input = strrep(my_input, '(-', '(!');
    my_input = strrep(my_input, '-', '+!');
    my_input = open_brackets(my_input);
    % disp(my_input)

    % my_input = strrep(my_input, '{>', '{+');
    my_input = strrep(my_input, '{<', '{-');

    for s = 1:(n-1)
        my_input = strrep(my_input, names.pop(), values_arr.pop());
    end
    % disp(my_input)

    output = my_input;
