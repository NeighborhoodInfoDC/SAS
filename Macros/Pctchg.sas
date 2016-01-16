/**************************************************************************
 Macro:    Pctchg
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/10/05
 Version:  SAS 8.2
 Environment:  Windows & Alpha
 
 Description:  Autocall macro for calculating percentage change
 between two numbers, <start> and <end>.

 Modifications:
**************************************************************************/

%macro pctchg( start, end );
  ( 100 * ( ( (&end) / (&start) ) - 1 ) )
%mend pctchg;

