function [clean_pd] = filter_out_blinks(pd)

pd(pd==0) = nan;

% remove points where two pupil diameters are out of whack
thresh = 0.02;
[~, idx] = remove_pd_outliers_NEW(pd(:,1)-pd(:,2), thresh);
pd(idx, :) =  nan;

pd = nanmean(pd,2);

% window

win = 100;
for i = win+1:(length(pd)-(win+1))
data = pd(i-win:i+win);
if pd(i)>(nanmedian(data)+3*mad(data))
    data_ind(i) = true;
elseif pd(i)<(nanmedian(data)-3*mad(data));
    data_ind(i) = true;
else data_ind(i) = false;
end
end

pd(data_ind) = nan;



clean_pd = pd;






