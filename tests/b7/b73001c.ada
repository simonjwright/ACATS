-- B73001C.ADA

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
--
-- OBJECTIVE:
--    CHECK THAT IF AN INCOMPLETE TYPE IS DECLARED IN THE PRIVATE PART OF A
--    PACKAGE AND NO FULL DECLARATION IS PROVIDED IN THE SAME PRIVATE
--    PART, THEN A PACKAGE BODY IS REQUIRED.
--
-- PASS/FAIL CRITERIA:
--    The test contains several lines marked POSSIBLE ERROR: [Setn].
--    For each value of n, the implementation must detect one or more of
--    these possible errors. For instance, an error must be detected on
--    at least one of the lines labeled POSSIBLE ERROR: [Set1] for an
--    implementation to pass.
--
-- CHANGE HISTORY:
--    JBG 09/19/83
--    RLB 02/06/17  Added additional error tags so reasonable error
--                  reporting strategies are directly supported.
--
--!

PROCEDURE B73001C IS

     PACKAGE PACK1 IS   -- POSSIBLE ERROR: [Set1] {6}
          TYPE T IS PRIVATE;
     PRIVATE
          TYPE INC;     -- OPTIONAL ERROR: {11}
          TYPE T IS ACCESS INC;
     END PACK1;

BEGIN                   -- POSSIBLE ERROR: [Set1] {2:6} BODY OF PACK1 MISSING.
     NULL;
END B73001C;
