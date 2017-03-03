clear all;
close all;

userdefinedfiles = 0;
if userdefinedfiles 
    [fname path_name] = uigetfile( {'*.acq';'*.txt';'*.*'}, ...
        'Choose file with EMG aquisition',...
        'MultiSelect', 'on');

    if iscell(fname) && length( fname ) > 1
        fname = sort( fname );
    else
        dummy = fname;
        clear fname;
        fname{1} = dummy;
    end
    
    for k = 1:length( fname )
        emgfiles(k).name = fname{k};
    end
    rootdir = path_name;
    
else
    rootdir = 'Z:\PRJ1206_BLINDNESS\03_PROCS\EMG\SUJEITOS';
    emgfiles = dir( fullfile( rootdir, '*EXE.acq' ) );    
end

delays = importdata( 'Z:\PRJ1206_BLINDNESS\03_PROCS\EMG\delay_sujeitos_EMG.xlsx' );


RMS_EMG_EXE( emgfiles, rootdir, delays.data.Sheet1 );



