% returns initials and end indices of continuous indices
function start_end_inds = get_start_end_indices( continuous_indices )

d = diff( continuous_indices );

d = [5 d]; % include first dummy number to count first index

breaks = find(d > 1);

start_inds = continuous_indices( breaks );

%remove first end index
breaks(1) = [];

% end index is one before of breaks 
end_inds = continuous_indices( breaks-1 );

end_inds(end+1) = continuous_indices(end);

start_inds = start_inds';
end_inds = end_inds';

start_end_inds = [ start_inds ; end_inds ];

end