/**************************************************************************
 Program:  StdRemote.sas
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Updated:  11/3/13
 Version:  SAS 9.4
 
 Description:  Standard header file for remote Windows environment.
 
 NOTE: NEED TO FIX _USERID FOR REMOTE SESSIONS.

**************************************************************************/

%global _dcdata_l_drive _dcdata_r_drive _dcdata_l_path _dcdata_r_path 
        _dcdata_path _remote_session _remote_batch_submit _userid;

%let _dcdata_l_drive = ;
%let _dcdata_r_drive = F;
%let _dcdata_l_path = ;
%let _dcdata_r_path = &_dcdata_r_drive:\DCDATA\Libraries;
%let _dcdata_path = &_dcdata_r_path;

%let _remote_session = 1;

** Locations of SAS autocall macro libraries **;

filename uiautos  "F:\DCData\Uiautos"; /** TEMPORARY FOR TESTING **/
filename dcautos  "&_dcdata_r_drive:\DCData\SAS\Macros";
options sasautos=(dcautos uiautos sasautos);

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

%SAS_compatibility()

** Output title **;

title "&_library/&_program: Urban-Greater DC";

** Define General library for local session only **;

%DCData_lib( General, env=windows, macdef=dcautos uiautos sasautos )

%let _userid = %sysfunc( putc( %lowcase(&SYSUSERID), $longusr. ) );
