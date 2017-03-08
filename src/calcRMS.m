% tempo x channel
function rms = calcRMS( data )

n = size( data, 1);

rms = sqrt( sum( data.^2, 1 ) / n );

end