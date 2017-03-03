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
    emgfiles = dir( fullfile( rootdir, '*IMAG.acq' ) );    
end

delays = importdata( 'Z:\PRJ1206_BLINDNESS\03_PROCS\EMG\delay_sujeitos_EMG.xlsx' );

subjects = delays.data.Sheet1(:,1);

for k=1:length(subjects)
    s = sprintf( 'SUBJ%03i_IMAG.acq', subjects(k) );
    subj_names{k} = s;
    
    if isempty( strfind( { emgfiles.name }, s ) )
        warning( 'could not find %s', s )
    end

end

%% check if there are more files than required
ind_remove = [];
for k=1:length( {emgfiles.name } )
    
    if isempty( strfind( subj_names, emgfiles(k).name ) )
        warning( 'file %s not required', emgfiles(k).name )
        ind_remove = [ind_remove k];
    end

end

emgfiles(ind_remove) = [];

RMS_EMG_IMAG( emgfiles, rootdir, delays.data.Sheet1,  delays.textdata.Sheet1(2:end,4) );




