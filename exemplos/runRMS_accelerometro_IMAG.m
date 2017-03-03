clear all;
close all;

userdefinedfiles = 1;
if userdefinedfiles 
    [fname path_name] = uigetfile( {'*.txt';'*.dat';'*.*'}, ...
        'Choose file with acceleration sensor aquisition',...
        'MultiSelect', 'on');

    if iscell(fname) && length( fname ) > 1
        fname = sort( fname );
    else
        dummy = fname;
        clear fname;
        fname{1} = dummy;
    end
    
    for k = 1:length( fname )
        accfiles(k).name = fname{k};
    end
    rootdir = path_name;
    
else
    rootdir = 'Z:\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\Export\ACC_IMAG';
    accfiles = dir( fullfile( rootdir, '*.dat' ) );   
end

% pegar parâmetros
prompt = {'Tempo de bloco de repouso:','Tempo de bloco ativação:','Número de repetição dos blocos:', 'Diretório de output:','Plotar gráficos(s/n):'};
dlg_title = 'Input';
num_lines = 1;
def = {'20','20', '12', 'Z:\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\ACC-REGRESSOR', 's'};
N = 80;
answer = inputdlg(prompt,dlg_title,[num_lines, length(dlg_title)+N],def, 'on');

dur_rest_seg        = str2num( answer{1} );
dur_activation_seg  = str2num( answer{2} );
repetitions         = str2num( answer{3} );
outdir              = answer{4};
if strcmp( answer{5}, 'n' )
    plotar_graficos = false ;
else
    plotar_graficos = true ;
end
    
% preprocessamento no analyzer tem que estar com esse sampling rate 
fs_acc = 100; % taxa de amostragem

[signal R R_bloco] = RMS_accelerometro_IMAG_MINI_BLOCO( accfiles, rootdir, fs_acc, dur_rest_seg, dur_activation_seg, repetitions, plotar_graficos );


xlswrite( fullfile( outdir, ['Accelerometro-' datestr( now, 'yyyymmdd-HHMMSS' )] ), R );
if ~isempty( R_bloco )
    R_runs = summarize_run( R_bloco );
    xlswrite( fullfile( outdir, ['Accelerometro-blocos-' datestr( now, 'yyyymmdd-HHMMSS' )] ), R_bloco );
    xlswrite( fullfile( outdir, ['Accelerometro-runs-' datestr( now, 'yyyymmdd-HHMMSS' )] ), R_runs );
end

calcularRegressor = 0;
if calcularRegressor
    win_size = 1;
    for k=1:length(accfiles)
        
        signal_resampled{k} = moving_window_average( signal{k}', win_size, fs_acc);
        signal_resampled{k} = signal_resampled{k}';
        
    end
    
    signal_convolved = RMS_accelerometro_convolve( accfiles, signal_resampled, 1/win_size );
    
    fs_res = 1/win_size;
    
    result_dir = outdir;
    
    for k=1:length(accfiles)
        
        dlmwrite( fullfile( result_dir, ['vol_' accfiles(k).name(1:end-4) '.txt']), signal_convolved{k}(fs_res : 2*fs_res : end), 'newline', 'PC' );
        
    end
end