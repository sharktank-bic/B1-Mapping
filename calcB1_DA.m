function calcB1_DA (fileName1, fileName2, b1Out, smallestAngle) 
%% CALCULATE DOUBLE ANGLE B1 MAP
%
% This function calculates B1 maps from two MRI Minc files originating from
% a double angle sequence (e.g. file 1 = 60 deg, file 2 = 120 deg).
%
% *************************************************************************
%
% Example: calcB1_DA('lastname_firstname_date_id_7_mri.mnc', 'lastname_firstname_date_id_8_mri.mnc','b1_map.mnc',60)
%
% *************************************************************************
%
% ***CODE REQUIREMENTS: MINC Tools, Niak***
%
% *************************************************************************
%
% INPUT FUNCTION PARAMETERS
%
% FILENAME1: String containing the complete filename for the MINC file of
% the double angle acquisition with the lowest flip angle (smallestAngle).
%
% FILENAME2: String containing the complete filename for the MINC file of
% the double angle acquisition with the flip angle twice that of
% smallestAngle.
%
% B1OUT: String containing the filename of the outputted B1 map.
%
% SMALLESTANGLE: Flip angle used in creating the file described by
% fileName1, in degrees.
%
% *************************************************************************
%
% Date Created: November 14 2013
% Author: Mathieu Boudreau
% Institute: Montreal Neurological Institute
% Email: mathieu.boudreau2@mail.mcgill.ca
%
% Note: This code is not intended for diagnostic purposes. The author is
% not responsible for errors or bugs in the code. Use at your own risk.

%% Load Minc images

[dab1_1hdr, dab1_1] = niak_read_minc(fileName1);
[~, dab1_2] = niak_read_minc(fileName2);


%% Calculate B1
%

r = abs(dab1_2./dab1_1);      
cos_arg = 1/2*r;

% Filter out cases where cos_arg>1; cos_arg should not be greater than one, so must be noise
cos_arg = double(cos_arg).*(cos_arg<=1) + ones(size(cos_arg)).*(cos_arg>1);

alpha = acosd(cos_arg); % alpha is in deg

b1 = alpha/smallestAngle;

%% Write out B1 map
%

b1hdr = dab1_1hdr;
b1hdr.file_name = b1Out;
niak_write_minc(b1hdr,b1);
