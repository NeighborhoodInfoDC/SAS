/**************************************************************************
 Macro:    DCData_lib
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Updated:  11/2/04
 Version:  SAS 9.2

 Description:  Define NeighborhoodInfo DC SAS libraries for
 local and remote sessions. Sets macro and format search paths.

 Modifications:
  11/09/04 PAT Corrected MPRINT option problem.
  08/22/06 PAT Added ENV=, MACDEF= options.
  11/02/13 PAT Revised for use with new SAS server setup.
               Added opt. conf_drive= to support confidential drives. 
  04/07/14 PAT Added local=Y/N and remote=Y/N parameters to control 
               creation of local and remote library references, 
               respectively, in local session.
  11/30/15 PAT Change library order for local sessions with remote batch 
               submit (R->C->L) vs local batch submit (C->L->R[read only]). 
**************************************************************************/

%macro DCData_lib( library, mprint=n, env=, macdef=, conf_drive=, local=y, remote=y, rreadonly= );

  %local conf_path prename l_exist r_exist c_exist l_ref r_ref c_ref
         l_libname r_libname c_libname;

  %let mprint = %upcase( &mprint );
  %let env = %upcase( &env );
  %let local = %upcase( &local);
  %let remote = %upcase( &remote ); 
  %let rreadonly = %upcase( &rreadonly );

  %if &mprint = N %then %do;
    options nomprint;
  %end;
  
  %** Create shortened library/filename prefix **;
  
  %if %length( &library ) > 6 %then %do;
    %let prename = %substr( &library, 1, 6 );
  %end;
  %else %do;
    %let prename = &library;
  %end;
  
  %let l_ref = 0;
  %let r_ref = 0;
  %let c_ref = 0;
  
  %let l_libname = ;
  %let r_libname = ;
  %let c_libname = ;
  
  %if not &_remote_session %then %do;
  
    %**** Set up libraries for LOCAL session (running on PC) ****;

    %** Default list of base macro search locations **;
    
    %if &macdef = %then %do;
      %if &_remote_batch_submit %then %let macdef = genera_r genera_l dcautos uiautos sasautos;
      %else %let macdef = genera_l genera_r dcautos uiautos sasautos;
    %end;
  
    %** Set up libraries for local session **;
  
    %** Confidential folder path (if drive specified) **;
    
    %if &conf_drive ~= %then %do;
      %let conf_path = %sysfunc( substr( &conf_drive, 1, 1 ) ):\DCData\Libraries;
      %let c_exist = %DirExist( &conf_path\&library );
    %end;
    %else %do;
      %let conf_path = ;
      %let c_exist = 0;
    %end;

    ** Create separate and concatenated libraries for data sets and format catalogs **;
    
    %let l_exist = %DirExist( &_dcdata_l_path\&library );
    %let r_exist = %DirExist( &_dcdata_r_path\&library );
    
    %if &l_exist = 0 and &r_exist = 0 and &c_exist = 0 %then %do;
      %err_mput( macro=DCData_lib, 
                 msg=The library %upcase(&library) does not exist on any of the %str(local, remote, or confidential drives). )
      %goto exit_macro;
    %end;
    
    %if &c_exist %then %do;
      %let c_libname = &prename._c;
      libname &c_libname "&conf_path\&library\Data";
      %let c_ref = 1;
    %end;
    %else %if &conf_drive ~= %then %do;
      %note_mput( macro=DCData_lib, msg=The library %upcase(&library) does not exist on %upcase(&conf_path). )
    %end;
    
    %if not( &local = N or &local = NO ) %then %do; 
      %if &l_exist %then %do;
        %let l_libname = &prename._l;
        libname &l_libname "&_dcdata_l_path\&library\Data";
        %let l_ref = 1;
      %end;
      %else %do;
        %note_mput( macro=DCData_lib, msg=The library %upcase(&library) does not exist on %upcase(&_dcdata_l_path). )
      %end;
    %end;
        
    %if not( &remote = N or &remote = NO ) %then %do; 
      %if &r_exist %then %do;
        %let r_libname = &prename._r;
        %if ( &_remote_batch_submit or &rreadonly = N ) and &rreadonly ~= Y %then %do;
          libname &r_libname "&_dcdata_r_path\&library\Data";
        %end;
        %else %do;
          libname &r_libname "&_dcdata_r_path\&library\Data" access=readonly;
          %note_mput( macro=DCData_lib, msg=Access to remote library %upcase(&r_libname) is read only. )
        %end;
        %let r_ref = 1;
      %end;
      %else %do;
        %note_mput( macro=DCData_lib, msg=The library %upcase(&library) does not exist on %upcase(&_dcdata_r_path). )
      %end;
    %end;
    
    %if &l_libname.&r_libname.&c_libname = %then %do;
      %warn_mput( macro=DCData_lib, msg=No references for %upcase(&library) have been created. )
      %goto exit_macro;
    %end;
        
    %if &_remote_batch_submit %then %do;
      %** Local session, remote batch submit **;
      libname &library ( &r_libname &c_libname &l_libname );
    %end;
    %else %do;
      %** Local session, local batch/interactive submit **;
      libname &library ( &c_libname &l_libname &r_libname );
    %end;
    
    ** Add concatenated library to format search **;
    
    %FmtSearch( cat=&library, action=E )

    ** Create filename references for autocall macro searching **;

    %if &_remote_batch_submit %then %do;
      %** Local session, remote batch submit **;
      %if &r_exist and &r_ref %then %do;
        filename &prename._r "&_dcdata_r_path\&library\Macros";
        %MacroSearch( cat=&prename._r, action=M, def=&macdef )
      %end;
      %if &c_exist and &c_ref %then %do;
        filename &prename._c "&conf_path\&library\Macros";
        %MacroSearch( cat=&prename._c, action=M, def=&macdef )
      %end;
      %if &l_exist and &l_ref %then %do;
        filename &prename._l "&_dcdata_l_path\&library\Macros";
        %MacroSearch( cat=&prename._l, action=M, def=&macdef )
      %end;
    %end;
    %else %do;
      %** Local session, local batch/interactive submit **;
      %if &c_exist and &c_ref %then %do;
        filename &prename._c "&conf_path\&library\Macros";
        %MacroSearch( cat=&prename._c, action=M, def=&macdef )
      %end;
      %if &l_exist and &l_ref %then %do;
        filename &prename._l "&_dcdata_l_path\&library\Macros";
        %MacroSearch( cat=&prename._l, action=M, def=&macdef )
      %end;
      %if &r_exist and &r_ref %then %do;
        filename &prename._r "&_dcdata_r_path\&library\Macros";
        %MacroSearch( cat=&prename._r, action=M, def=&macdef )
      %end;
    %end;
  %end;
  %else %do;
  
    %**** Set up libraries for REMOTE session (running on SAS1) ****;
    
    %** Default list of base macro search locations **;
    
    %if &macdef = %then %let macdef = general dcautos uiautos sasautos;
  
    ** Create library for data sets and format catalogs **;
    
    %let r_exist = %DirExist( &_dcdata_r_path\&library );
    
    %if &r_exist = 0 %then %do;
      %err_mput( macro=DCData_lib, 
                 msg=The library %upcase(&library) does not exist on remote drive. )
      %goto exit_macro;
    %end;
    
    %let r_libname = &prename._r;
    
    %if ( &_remote_batch_submit or &rreadonly = N ) and &rreadonly ~= Y %then %do;
      %** Remote session, remote batch submit **;
      libname &r_libname "&_dcdata_r_path\&library\Data";
    %end;
    %else %do;
      %** Remote session, interactive submit **;
      libname &r_libname "&_dcdata_r_path\&library\Data" access=readonly;
      %note_mput( macro=DCData_lib, msg=Access to remote library %upcase(&r_libname) is read only. )
    %end;

    libname &library ( &r_libname );
    
    ** Add library to format search **;
    
    %FmtSearch( cat=&library, action=E )

    ** Create filename references for autocall macro searching **;

    filename &library "&_dcdata_r_path\&library\Macros";
    
    %MacroSearch( cat=&library, action=M, def=&macdef )

  %end;
  
  %exit_macro:

  %if &mprint = N %then %do;
    options mprint;
  %end;

%mend DCData_lib;


