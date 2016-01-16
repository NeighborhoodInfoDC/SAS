/************************************************************************
* Macro:    DC_update_meta_library
* Library:  Macros
* Project:  NeighborhoodInfo DC
* Author:   P. Tatian
* Created:  11/02/04
* Version:  SAS 8.2
* Environment:  Alpha only
* 
* Description: Update library entry in metadata
* system.
*
* Modifications:
************************************************************************/

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




