/**************************************************************************
 Macro:    Octo_GeoBlk2010
 Library:  Octo
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/11/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description: Convert OCTO census block ID to
 NeighborhoodInfo DC standard var GeoBlk2010.
 
 Modifications:
  07/23/12 PAT Revised to conform with new OCTO 2010 block file vars.
  07/27/12 PAT Changed input var to conform with new version of 
               Block10Ply.shp created by R. Pitingolo.
               Restored INVAR= parameter.
**************************************************************************/

%macro Octo_GeoBlk2010( 
  outvar=GeoBlk2010, /** Output var name **/
  invar=geoid10,     /** Input var **/
  check=n            /** Perform validity check? (Y/N) **/
);

  length GeoBlk2010 $ 15;
  
  /**&outvar = '11001' || trim( left( Tract ) ) || trim( left( BlkGrp ) ) || left( Block );**/
  
  &outvar = left( &invar );
  
  label
    &outvar = "Full census block ID (2010): sscccttttttbbbb";

  %if %upcase( &check ) = Y %then %do;
    if put( &outvar, $blk10v. ) = '' then do;
      %warn_put( msg="Invalid 2010 block ID: " _n_= &outvar= &invar= )
    end;
  %end;

%mend Octo_GeoBlk2010;



