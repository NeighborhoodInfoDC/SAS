/************************************************************************
* Program:  DC_update_meta_library.sas
* Library:  Macros
* Project:  DC Data Warehouse
* Author:   P. Tatian
* Created:  11/02/04
* Version:  SAS 8.2
* Environment:  Alpha only
* 
* Description:  Autocall macro to update library entry in metadata
* system.
*
* Modifications:
************************************************************************/

/** Macro DC_update_meta_library - Start Definition **/

%macro DC_update_meta_library( 
         lib_name= ,
         lib_desc= ,
         quiet=N
  );

  %Update_metadata_library( 
         lib_name=&lib_name ,
         lib_desc=&lib_desc ,
         meta_lib=_metadat,
         meta_pre=meta,
         quiet=&quiet
  )

  ** Purge extra copies of metadata files **;

  %exit:
  %Note_mput( macro=DC_update_meta_library, msg=Exiting macro. )

%mend DC_update_meta_library;

/** End Macro Definition **/


