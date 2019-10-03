function [roller, outer, inner] = removeByLabel(x)
    roller = x;
    outer = x;
    inner = x;
    rollerRemove = [3, 4, 6];
    outerRemove = [2, 3, 5];
    innerRemove = [2, 4, 8];
    for i = 1:length(rollerRemove)       
        roller((roller(:, end) == rollerRemove(i)), :) = [];
        outer((outer(:, end) == outerRemove(i)), :) = [];
        inner((inner(:, end) == innerRemove(i)), :) = [];  
    end
    roller = normalize(roller,2);
    inner = normalize(inner,2);
    outer = normalize(outer,2);
end