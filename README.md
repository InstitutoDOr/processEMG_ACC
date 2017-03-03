# processEMG_ACC
Scripts for signal processing electromyography (EMG) or acceleration sensor data (ACC)

Pre-requisites:
- Input data in .txt/.dat or .acq (Biopac) files
- If used for convolution or block design analysis, signal must be synchronized with start block (signal before experiment start must be removed)

Basic Features:
- Calculates RMS of raw EMG signal or acceleration sensor data
- Extraction of mean RMS signal per block (user specifies blocks of data with regular length)
- Output to data sheets for statistical analysis
- Output plots of signal

Special Purpose Features:
- Convolution with hemodynamic response functions (HRF) to use signals as regressor in GLM analysis of fMRI data
- Grip detection for gripping hand movements measured with acceleration sensor



