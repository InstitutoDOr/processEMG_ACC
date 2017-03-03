% data time_points x variable
% type ='high' 'low' or stop
% is stop, cutoff_freq must be 1x2
function y = filterpass( data, cutoff_freq, sample_rate, type, order ) 

if nargin < 5
    order = 2;
end
Wn = cutoff_freq / sample_rate * 2 ;
[b,a] = butter(order,Wn,type);

y = filtfilt(b,a,data);

end