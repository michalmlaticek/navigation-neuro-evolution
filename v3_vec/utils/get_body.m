function body = get_body(radius) 
            body = [];
            for i = -radius:radius
                for j = -radius:radius
                    if i^2+j^2 <= radius^2 % is inside robot circle?
                        body = [body, [i; j]];
                    end
                end % for - j
            end % for - i
        end