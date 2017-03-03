
rootdir = 'Z:\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\Export\ACC_EXE';

files = dir( fullfile( rootdir, '*.dat' ) );

for k=1:length(files)
    fprintf( '%s\n', files(k).name );
    
   % if strfind( files(k).name, 'SUBJ016' )
        
    acc = load( fullfile( rootdir, files(k).name) );
    
    tit = strrep( files(k).name, '_', ' ');
    
    calc_Freq_Apertar
    
    res{k,1} = files(k).name(28:end-4);
    res{k,2} = number_mov;
    res{k,3} = m_freq;
    res{k,4} = vel_mean_peak;
    % end
end
   
R_header = {'SUJEITO', 'NUM_MOVIMENTO', 'FREQUENCIA', 'MEDIA_VELOCIDADE'};
res = [ R_header; res];
xlswrite( fullfile( 'Z:\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\RESULTADOS\', ['FREQ-EXECUCAO-Accelerometro-' datestr( now, 'yyyymmdd-HHMMSS' )] ), res );

