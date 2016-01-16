/**************************************************************************
 Macro:    Annchg
 Library:  Macros
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  01/10/05
 Version:  SAS 8.2
 Environment:  Windows & Alpha
 
 Description:  Autocall macro for calculating annual percentage
 change between two numbers, <start> and <end>.

 Modifications:
**************************************************************************/

%macro annchg( start, end, years );
  ( ( (&end) / (&start) ) ** ( 1 / (&years) ) - 1 )
%mend annchg;
