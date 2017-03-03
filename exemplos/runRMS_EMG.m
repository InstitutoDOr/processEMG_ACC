clear all;
close all;

userdefinedfiles = 1;
if userdefinedfiles 
    [fname path_name] = uigetfile( {'*.txt';'*.acq';'*.*'}, ...
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
    rootdir = 'Z:\PROJETOS\PRJ1206_BLINDNESS\03_PROCS\EMG\SUJEITOS';
    emgfiles = dir( fullfile( rootdir, '*.acq' ) );    
end

RMS_EMG( emgfiles, rootdir );




