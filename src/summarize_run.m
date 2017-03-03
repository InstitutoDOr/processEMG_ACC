function R_runs = summarize_run( R_blocks )

a = 'BLOCO ATIVACAO';
b = 'BLOCO REPOUSO';
num_digits_subj = 7;

a_ind = [];
b_ind = [];

% get indices for blocks
for k=2:size( R_blocks, 2 )

    if strcmp( R_blocks{1,k}, a )
        a_ind = [a_ind k];
    elseif strcmp( R_blocks{1,k}, b )
        b_ind = [b_ind k]; 
    end
    
end

% get all subjects and runs
subjids = [];
runids  = [];
for m=2:size( R_blocks, 1 )
    
   s = R_blocks{m,1}(1:num_digits_subj);
   r = R_blocks{m,1}(num_digits_subj+2:end);
   
   if isempty( find( strcmp( subjids, s ) ) )
       subjids{end+1} = s;
   end
   
   if isempty( find( strcmp( runids, r ) ) )
       runids{end+1} = r;
   end
   
end

for m=2:size( R_blocks, 1 )
    
   subj_ind = find( strcmp( subjids, R_blocks{m,1}(1:num_digits_subj) ) );
   run_ind = find( strcmp( runids, R_blocks{m,1}(num_digits_subj+2:end) ) );
   
   R_runs{1, run_ind*2     } = [runids{run_ind} '-ATIV'];
   R_runs{1, run_ind*2 + 1 } = [runids{run_ind} '-REP'];
   
   R_runs{subj_ind+1,1} = subjids{subj_ind} ;
   
   values_ativ = cell2mat( R_blocks(m,a_ind) );
   values_rep = cell2mat( R_blocks(m,b_ind) );
   
   R_runs{subj_ind+1, run_ind * 2     } = mean( values_ativ );
   R_runs{subj_ind+1, run_ind * 2 + 1 } = mean( values_rep );
   
   
end


end