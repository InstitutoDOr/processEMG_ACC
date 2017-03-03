function tit = makeTitle( fname )

    in = strfind( fname, 'SUBJ' );
%    ul = strfind( fname, '_' );
    tit =  fname( in(1) : end-4 );
    tit = strrep( tit, '_' , '-' ); 
    
end