rdir = 'Z:\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\Export';

ddir = 'Z:\PRJ1206_BLINDNESS\03_PROCS\ACCELEROMETRO\Export\ACC_IMAG';

files = dir( fullfile(rdir, '*Segment 2.dat' ) );

for k=1:length(files)
    
    copyfile( fullfile(rdir, files(k).name ), fullfile( ddir, [files(k).name(1:35) 'IMAG_RUN2.dat'] ) );
    
end

files = dir( fullfile(rdir, '*Segment 3.dat' ) );

for k=1:length(files)
    
    copyfile( fullfile(rdir, files(k).name ), fullfile( ddir, [files(k).name(1:35) 'IMAG_RUN3.dat'] ) );
    
end