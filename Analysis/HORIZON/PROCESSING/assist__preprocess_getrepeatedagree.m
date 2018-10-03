function agree = assist__preprocess_getrepeatedagree(ID, key)
    agree = repmat(NaN, length(ID), 1);
    for i = 1:length(ID)
        if ID(i) < 0
            agree(i) = NaN;
        else
            idx = find(ID == ID(i));
            cs = arrayfun(@(x)key(x), idx);
            agree(i) = (length(unique(cs)) == 1) + 0;
        end
    end
end