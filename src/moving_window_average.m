function data_windowed = moving_window_average( data, tempo_em_seg, fs )

    data2 = data .* data ;
    
    meanhandle = @(d) mean(d,2);
    data_windowed_cell = moving_window( data2, tempo_em_seg, fs, meanhandle );
    
    data_windowed = cell2mat( data_windowed_cell );

end