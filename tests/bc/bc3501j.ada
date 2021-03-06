-- BC3501J.ADA

--                             Grant of Unlimited Rights
--
--     Under contracts F33600-87-D-0337, F33600-84-D-0280, MDA903-79-C-0687,
--     F08630-91-C-0015, and DCA100-97-D-0025, the U.S. Government obtained 
--     unlimited rights in the software and documentation contained herein.
--     Unlimited rights are defined in DFAR 252.227-7013(a)(19).  By making 
--     this public release, the Government intends to confer upon all 
--     recipients unlimited rights  equal to those held by the Government.  
--     These rights include rights to use, duplicate, release or disclose the 
--     released technical data and computer software in whole or in part, in 
--     any manner and for any purpose whatsoever, and to have or permit others 
--     to do so.
--
--                                    DISCLAIMER
--
--     ALL MATERIALS OR INFORMATION HEREIN RELEASED, MADE AVAILABLE OR
--     DISCLOSED ARE AS IS.  THE GOVERNMENT MAKES NO EXPRESS OR IMPLIED 
--     WARRANTY AS TO ANY MATTER WHATSOEVER, INCLUDING THE CONDITIONS OF THE
--     SOFTWARE, DOCUMENTATION OR OTHER INFORMATION RELEASED, MADE AVAILABLE 
--     OR DISCLOSED, OR THE OWNERSHIP, MERCHANTABILITY, OR FITNESS FOR A
--     PARTICULAR PURPOSE OF SAID MATERIAL.
--*
-- CHECK THAT IF A FORMAL GENERIC TYPE FT IS AN ACCESS TYPE, THE
-- CORRESPONDING ACTUAL TYPE PARAMETER MUST BE AN ACCESS TYPE.

-- CHECK THAT FT DOES NOT MATCH AN ACTUAL TYPE THAT IS THE BASE TYPE OF
-- THE FORMAL PARAMETER'S DESIGNATED TYPE.  

-- CHECK WHEN THE DESIGNATED TYPE IS NOT A GENERIC FORMAL TYPE DECLARED 
-- IN THE SAME FORMAL PART AS FT.

-- CHECK WHEN THE DESIGNATED TYPE IS A FIXED OR FLOAT TYPE.

-- SPS 5/18/82

PROCEDURE BC3501J IS

     TYPE AF IS ACCESS FLOAT;

     GENERIC
          TYPE FT IS ACCESS FLOAT;
     PACKAGE Q IS END Q;

     PACKAGE Q1 IS NEW Q (AF);               -- OK.
     PACKAGE Q2 IS NEW Q (FLOAT);            -- ERROR: FLOAT IS NOT AN
                                             -- ACCESS TYPE.

     TYPE FX IS DELTA 0.1 RANGE 1.0 .. 3.0;
     TYPE AFX IS ACCESS FX;

     GENERIC
          TYPE FT IS ACCESS FX;
     PACKAGE QA IS END QA;

     PACKAGE Q3 IS NEW QA (AFX);             -- OK.
     PACKAGE Q4 IS NEW QA (FX);              -- ERROR: FX IS NOT
                                             -- AN ACCESS TYPE.

BEGIN
     NULL;
END BC3501J;
