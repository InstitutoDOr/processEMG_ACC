function init()

mdir = fileparts(mfilename('fullpath'));

addpath( fullfile(mdir,'src') );
addpath( fullfile(mdir,'vendors/load_acq') );