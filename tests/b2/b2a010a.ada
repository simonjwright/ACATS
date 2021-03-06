-- B2A010A.ADA

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
-- CHECK THAT A BASED LITERAL CANNOT START WITH A SHARP SIGN AND END 
-- WITH A COLON OR VICE VERSA.

-- TBN 2/27/86

PROCEDURE B2A010A IS

     TYPE FLOAT1 IS DIGITS 5;
     TYPE FLOAT2 IS DIGITS 2#11: ;                             -- ERROR:
     TYPE MY_INT IS RANGE -10 .. 1_6:AB#E1;                    -- ERROR:
     TYPE REC1 (DISC: INTEGER := 10#29_182:) IS                -- ERROR:
          RECORD
               NULL;
          END RECORD;

     TYPE ARRAY1 IS ARRAY (INTEGER RANGE <>) OF BOOLEAN;
     OBJ_ARA1 : ARRAY1 (1 .. 2:1_11#E1);                       -- ERROR:
     VAR1 : FLOAT1 := 16#F.F_EE: ;                             -- ERROR:
     CON1 : CONSTANT FLOAT1 := 2:1.01#E2;                      -- ERROR:
     VAR2 : INTEGER := 4#123:E2;                               -- ERROR:
     INT1 : INTEGER := 2#1# ;
     FLO1 : FLOAT1 := 10:2.5:E1;
     CHAR1 : CHARACTER;

BEGIN

     IF INT1 > 2:11#E1 OR                                      -- ERROR:
        FLO1 < 16#F.F: THEN                                    -- ERROR:
          INT1 := 16#1: ;                                      -- ERROR:
          FLO1 := 2:1.1# ;                                     -- ERROR:
     END IF;

     CASE INT1 IS
          WHEN 2:11# =>                                        -- ERROR:
               CHAR1 := CHARACTER'VAL(2#111:E1);               -- ERROR:
          WHEN OTHERS =>
               NULL;
     END CASE;

END B2A010A;
