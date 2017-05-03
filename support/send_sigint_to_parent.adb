--  This program is spawned by Impdef.Annex_C to send a SIGINT to its
--  parent process (the test case itself).
--
--  You would have thought we could just call raise(SIGINT), which
--  works in C; unfortunately, it doesn't work in GNAT Ada.

with GNAT.OS_Lib; use GNAT.OS_Lib;
procedure Send_Sigint_To_Parent is
   function Getppid return Process_Id
     with
       Import,
       Convention => C,
       External_Name => "getppid";
begin
   Kill (Getppid, Hard_Kill => False);
end Send_Sigint_To_Parent;
