function set_checked = region_finder(index,S3_Q1, u_th, l_th)
    Set = index;
    set_idex = 2;
    set_checked = zeros(256, 256);
    set_checked (Set) =1 ;
    new = 1;
    while 1
        if (new ==0)
            break;
        end
        new = 0;
    %     [Set, set_idex] = checker (Set, set_idex,S3_Q1);
        for i = 1 : set_idex -1
            % down
            if (S3_Q1(Set(i)-1)<=u_th) && (S3_Q1(Set(i)-1)>=l_th)
                if (set_checked (Set(i)-1) == 0)
                    new = 1;
                    set_checked (Set(i)-1) = 1;
                    Set(set_idex) = Set(i)-1;
                    set_idex = set_idex + 1;
                end
            end

            % up
            if (S3_Q1(Set(i)+1)<=u_th)&& (S3_Q1(Set(i)+1)>=l_th)
                if (set_checked (Set(i)+1) == 0)
                    new = 1;
                    set_checked (Set(i)+1) = 1;
                    Set(set_idex) = Set(i)+1;
                    set_idex = set_idex + 1;
                end
            end

            % right
            if (S3_Q1(Set(i)+256)<=u_th)&& (S3_Q1(Set(i)+256)>=l_th)
                if (set_checked (Set(i)+256) == 0)
                    new = 1;
                    set_checked (Set(i)+256) = 1;
                    Set(set_idex) = Set(i)+256;
                    set_idex = set_idex + 1;
                end
            end

            % left
            if (S3_Q1(Set(i)-256)<=u_th) && (S3_Q1(Set(i)-256)>=l_th)
                if (set_checked (Set(i)-256) == 0)
                    new = 1;
                    set_checked (Set(i)-256) = 1;
                    Set(set_idex) = Set(i)-256;
                    set_idex = set_idex + 1;
                end
            end
        end
    end
end

