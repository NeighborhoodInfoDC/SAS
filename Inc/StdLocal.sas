/**************************************************************************
 Program:  StdLocal.sas
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Updated:  11/2/13
 Version:  SAS 9.4
 
 Description:  Standard header file for local Windows session.

**************************************************************************/

%global _dcdata_l_drive _dcdata_r_drive _dcdata_l_path _dcdata_r_path 
        _dcdata_path _dcdata_default_path _dcdata_census_api_key
        _remote_session _remote_batch_submit _userid;

** Check to see if drive letters are assigned in Autoexec, otherwise, default to C: and \\sas1 **;
%macro checkdrives ();
%if %length(&_dcdata_l_drive)=0 %then %do;
	%let _dcdata_l_drive = C:;
%end;

%if %length(&_dcdata_r_drive)=0 %then %do;
	%let _dcdata_r_drive = \\sas1;
%end;
%mend checkdrives;
%checkdrives;

** Define DC Data paths **;
%let _dcdata_l_path = &_dcdata_l_drive\DCData\Libraries;
%let _dcdata_r_path = &_dcdata_r_drive\DCData\Libraries;
%let _dcdata_path = &_dcdata_r_path;

%let _remote_session = 0;

** Locations of SAS autocall macro libraries **;

filename uiautos  "&_dcdata_r_drive\DCData\Uiautos"; 
filename dcautos  "&_dcdata_r_drive\DCData\SAS\Macros";
options sasautos=(dcautos uiautos sasautos);

** Program name & library **;

%GetProgName( _program )
%GetProgLib( _library )
%GetProgDrive( _pdrive )

%let _remote_batch_submit = %is_remote_batch( &_pdrive );
%let _dcdata_default_path = %mif_select( &_remote_batch_submit, &_dcdata_r_path, &_dcdata_l_path );

** Metadata library **;

libname _metadat "&_dcdata_r_path\Metadata\Data";

** System options **;

options compress=yes msglevel=i nocenter mprint nofmterr source2 minoperator mindelimiter=','
        mergenoby=warn formchar="|----|+|---+=|-/\<>*";

options ls=124 ps=48;    ** Landscape **;

%SAS_compatibility()

** Output title **;

title "&_library/&_program: Urban-Greater DC";

** Define General library for local session only **;

%DCData_lib( General, env=windows, macdef=dcautos uiautos sasautos )

%let _userid = %sysfunc( putc( %lowcase(&SYSUSERID), $longusr. ) );

** Load Census API key **;

%include "&_dcdata_r_drive\DCData\SAS\Inc\Census_api.key";
