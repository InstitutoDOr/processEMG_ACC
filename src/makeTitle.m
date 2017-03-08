function tit = makeTitle( fname )

    names = regexp(fname, 'SUBJ(?<subn>\d+)(?<segment>.*).{4}$', 'names');
    tit = sprintf( 'SUBJ%03d%s', str2double(names.subn), names.segment );
    tit = strrep( tit, '_' , '-' );
    
end