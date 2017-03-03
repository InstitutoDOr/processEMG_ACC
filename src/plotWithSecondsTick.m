function plotWithSecondsTick( data, sample_rate, ylab )

plot( data, 'Linewidth', 2 )
if ~isempty( ylab )
    ylabel( ylab );
end
xticklabel = [0:20*sample_rate:size(data,1)-1]/sample_rate;
xticks = [1:20*sample_rate:size(data,1)];
set(gca,'XTick',xticks,'XTickLabel',xticklabel);
xlabel( 'tempo em segundos' );

end