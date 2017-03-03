% calculates mean value for every window
% data: n x m n channels, m data points 
% win_size_secs: size of window to average
% fs: sample_rate
% returns mean of every time window and middle position of every time
% window in variable time_window
function [data_windows time_windows] = moving_window( data, win_size_secs, fs, fhandle )

data_windows = [];
time_windows = [];

count = 0;
for k=1 : ceil(win_size_secs*fs) : size(data,2)
   inds = k : k+ceil(win_size_secs*fs)-1;
   
   if sum( inds > size(data,2) ) > 0 
       inds( inds > size(data,2) ) = [];
       last_win_length = length( inds ) / fs;
   end
   data_windows{end+1} = feval( fhandle, data(:,inds) );
   time_windows(end+1) = (k-1)*win_size_secs/2;
   count = count + 1;
end

disp( sprintf( 'Averaged %s windows', num2str(count) ) ) 

if exist( 'last_win_length', 'var' )
   disp(sprintf( 'Last window length: %d', last_win_length ) )
end

end

