-- BA1010D1.ADA

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
-- OBJECTIVE:
--     SEE BA1010D0M.ADA.

-- TEST FILES:
--      THIS TEST CONSISTS OF THE FOLLOWING FILES:
--         BA1010D0M.ADA - SPECIFICATION FOR SUBPROGRAM BA1010D. THIS
--                         FILE SHOULD COMPILE WITHOUT ERRORS.
--      -> BA1010D1.ADA  - BODY FOR SUBPROGRAM BA1010D.
--         BA1010D2.ADA  - BODY FOR SUBPROGRAM BA1010D.
--         BA1010D3.ADA  - BODY FOR SUBPROGRAM BA1010D.

-- HISTORY:
--     JET 07/29/88  CREATED ORIGINAL TEST.
--     THS 04/12/90  MOVED "-- ERROR:" TO THE RIGHT OF THE CONSTRUCT
--                   IN ERROR AND SPLIT TEST TO BA1010J1, BA1010K1,
--                   BA1010L1, BA1010M1, BA1010N1, BA1010P1, BA1010Q1.
--     RLB 09/13/99  UPDATED APPLICABILITY CRITERIA AND HEADERS FOR ADA 95.


PROCEDURE BA1010D (I : INTEGER := 5) IS   -- ERROR: DOESN'T MATCH SPEC.
BEGIN
     NULL;
END BA1010D;
