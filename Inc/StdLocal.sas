/**************************************************************************
 Program:  StdLocal.sas
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Updated:  11/2/13
 Version:  SAS 9.2
 
 Description:  Standard header file for local Windows session.

**************************************************************************/

%global _dcdata_l_drive _dcdata_r_drive _dcdata_l_path _dcdata_r_path 
        _remote_session _remote_batch_submit _userid;

%let _dcdata_l_drive = D;
%let _dcdata_r_drive = L;
%let _dcdata_l_path = &_dcdata_l_drive:\DCData\Libraries;
%let _dcdata_r_path = &_dcdata_r_drive:\Libraries;
%let _dcdata_path = &_dcdata_r_path;

%let _remote_session = 0;

** Locations of SAS autocall macro libraries **;

filename uiautos  "L:\Uiautos"; /** TEMPORARY FOR TESTING **/
filename dcautos  "&_dcdata_r_drive:\SAS\Macros";
filename ttautos  "D:\DCData\SAS\Macros";
options sasautos=(ttautos dcautos uiautos sasautos);

** Program name & library **;

%GetProgName( _program )
%GetProgLib( _library )
%GetProgDrive( _pdrive )

%let _remote_batch_submit = %is_remote_batch( &_pdrive );

** Metadata library **;

libname _metadat "&_dcdata_r_path\Metadata\Data";

** System options **;

options compress=yes msglevel=i nocenter mprint nofmterr source2 
        mergenoby=warn formchar="|----|+|---+=|-/\<>*";

options ls=124 ps=48;    ** Landscape **;

** Output title **;

title "&_library/&_program:  NeighborhoodInfo DC";

** Define General library for local session only **;

%DCData_lib( General, env=windows, macdef=dcautos uiautos sasautos )

%let _userid = %sysfunc( putc( %lowcase(&SYSUSERID), $longusr. ) );
