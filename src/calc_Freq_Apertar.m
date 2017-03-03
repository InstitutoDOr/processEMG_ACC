
%%
clear acc_s;
clear acc_sf;

Fs = 100;
span = 0.5 * Fs;

for d=1:3
    acc_s(d,:) = smooth( acc(d,:), span );
end

for d=1:3
    acc_sf(d,:) = filterpass( acc_s(d,:), 0.5, Fs, 'high', 2); % remove baseline
end

for d=1:3
    acc_sf(d,:) = filterpass( acc_sf(d,:), 2, Fs, 'low', 2); % remove baseline
end


% especificacao da unidade do acelerometro: 420mV por g
acc_sf = acc_sf / 1000 / 420; % convert units to multiple of g = 9,81 m / s^2

check_peaks = true;
if check_peaks, figure, end

col = 'gkb';
lim = 0.03;
for d=3:3
    
     % pegar valores  acima de um limiar
     inds = acc_sf(d,:) > 0.03;
     
     % determina partes do movimento de maior acceleração
     move_start = find( diff( inds ) == 1 );
     move_end   = find( diff( inds ) == -1 );
     
     num_mov = min( length(move_start), length(move_end) );
     
     a =[];
     ind_mov = [];
     
     % encontra o peak (máximo de acceleração) em cada movimento
     for mov=1:num_mov
         
        [a(mov) ind_mov(mov)] = max( acc_sf(d, move_start(mov):move_end(mov) ) );
        
        % corrigir pelo offset (move_start)
        ind_mov(mov) = ind_mov(mov) + move_start(mov);
     end
        
     if check_peaks
         plot( acc_sf(d,:), col(d) );
         hold on, plot( ind_mov, acc_sf( d, ind_mov), 'or' );
         title( tit )
         set( gca, 'xtick', 1:10*Fs:size(acc_sf,2), 'xticklabel', [0:10:size(acc_sf,2)/Fs])
         xlabel( 'tempo em segundos' ), ylabel( 'aceleração em múltiplos de g' )
     end
     
     max_acc{d} = a;
     max_acc_ind{d} = ind_mov;
end

% pegar canal mais discriminativo (maior quantidade e maiores picos na média)
for d=1:3
   med(d) = mean( max_acc{d} ) ;
   num(d) = length( max_acc_ind{d} );
end

% dar prioridade a maior numero de movimentos detectados
% if all( diff( num ) == 0 )
%     [a i] = max( num );
%     time_between_peaks = diff( max_acc_ind{i} ) / Fs;
% else
    % dar prioridade a maior amplitude dos picos
    [a i] = max( med );
    time_between_peaks = diff( max_acc_ind{i} ) / Fs;    
% end

% report final
outlier_thresh = 3; % não considerar peaks que são mais distantes do que outlier_thresh
m_freq = 1 / mean( time_between_peaks( time_between_peaks < outlier_thresh ) );
number_mov = length( time_between_peaks ) + 1;

[a i] = max( med );
vel_mean_peak = med(i);

fprintf( 'Mean frequency: % .2f\nNumber of movementos detected:%i\nMean peak acceleration (g=9.81m/s^2): %.2f\n', m_freq, number_mov, vel_mean_peak )


