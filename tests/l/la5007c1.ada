-- LA5007C1M.ADA

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
-- CHECK THAT EXECUTION OF A MAIN PROGRAM IS NOT ALLOWED IF A NEEDED
--   NON-GENERIC UNIT IS MISSING OR OBSOLETE.

-- CASE C:  MISSING LIBRARY PACKAGE BODY.

-- SEPARATE FILES ARE:
--   LA5007C0  A LIBRARY PACKAGE DECLARATION.
--   LA5007C1M THE MAIN PROCEDURE.

-- EXPECT A LINK-TIME ERROR MESSAGE THAT THE BODY OF PACKAGE LA5007C0
--   IS MISSING.

-- JRK 6/3/85

WITH REPORT; USE REPORT;
WITH LA5007C0;

PROCEDURE LA5007C1M IS
BEGIN
     TEST ("LA5007C", "CHECK THAT MAIN PROGRAM NOT EXECUTED IF A " &
                      "LIBRARY PACKAGE BODY IS MISSING");

     FAILED ("SHOULD NOT EXECUTE");

     RESULT;
END LA5007C1M;
