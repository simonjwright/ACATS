# ACATS #

This repository contains a version of
the [Ada Conformity Assessment Test Suite][Ada-Auth] customised for
use with FSF GCC. Eventually it's hoped they will replace the current
GCC tests (based on ACATS 2.5).

The current version here is 4.1W.

## Notes ##

To run the tests, you'll need `expect` (and `tcl`) installed.

### Test changes ###

Test CXH1001 as released fails; if the GNAT binder encounters the
configuration pragma `Normalize_Scalars`, it requires all the units in
the partition to have been compiled with it, including the runtime
system. Replaced here by the GNAT-specific `Initialize_Scalars`.

Some individual tests are in any case suppressed (by inclusion in the
file `norun.lst`), because they involve another language (Fortran,
Cobol).

The tests that involve timing mostly included very long timeouts (up
to an hour in some cases), which were scaled here (as in the GCC
version) by multiplying by `One_Nominal_Second` (0.001 seconds) or
`One_Nominal_Long_Second` (0.1 seconds). This problem was corrected in
ACATS 4.1M, and the code here matches the official version.

### Testing in GCC ###

You can run the GCC checks with this version of the tests (provided
you have `dejagnu` installed as well as `expect`) by replacing
`gcc/testsuite/ada/acats` in the source tree by (a link to) this code
and then, in the `gcc` directory of the build tree, run `make
check-acats`. (You can also run `make check-gnat` for the GNAT tests,
or `make check-ada` for both).

You can run the tests in parallel, which of course makes most sense if
you have multiple cores, by for example `make -j4 check-acats`. If you
do this, the screen output during execution is misleading; only the
final `acats.log` and `acats.sum` in
`<build-dir>/gcc/testsuite/ada/acats/` are meaningful.

The default compiler options are `-gnatws -g -O2` (`-gnat2012` is
always added). You can pass additional options using the
`RUNTESTFLAGS` feature:

    make check-acats RUNTESTFLAGS="--target_board=unix/-O3/-gnatN"

runs the tests with `-gnatws -gnatN -g -O2 -O3`.

If you wish to pass any GNAT-specific options (e.g. `-gnat*`) you must
only run this suite (`make check-acats`), because `-gnat*` will fail
with most other tools (`unrecognized debug output level 'nat*'`).

Don't use `RUNTESTFLAGS` with `-j<n>`: it doesn't get passed to
sub-makes (as of 2018-02-10).

### Local testing ###

You can also run the tests, or individual chapters of the tests, by
using the `run_local.sh` script (from a different directory). For
example,

    mkdir ~/tmp/acats
    cd ~/tmp/acats
    ~/ACATS/run_local.sh cxd cxe

(assuming this repository is installed at `~/ACATS`) will run just
chapters CXD, CXE (execution tests on Annexes D and E), using the
current compiler. With no arguments, all tests are run.

The above command will only build the support code if it isn't already
built. To force a rebuild, say

    ~/ACATS/run_local.sh NONE cxd cxe

### Reports ###

The reports are in `acats.log` and `acats.sum`.

`acats.log` is a full report of test compilation, build and execution.

`acats.sum` is a report of just the outcome of each test and a summary.

The outcomes are reported in the style `OUTCOME: test`, e.g. `PASS: a22006b`, where the possible outcomes are

  * `PASS`: the test passed
  * `FAIL`: the test was expected to pass but failed
  * `XFAIL`: the test was expected to fail and did so
  * `XPASS`: the test was expected to fail but passed
  * `UNRESOLVED`: the test requires visual examination to finally
    determine pass/fail
  * `UNSUPPORTED`: the test was either deemed not applicable by the
    test itself (for example, C45322A requires `Machine_Overflows` to
    be `True`), not supported by the compiler (for example, CXAG002
    will not compile because it requires support for
    `Hierarchical_File_Names`), or not compatible with simple use of
    _gnatchop_ (because the test contains the same unit in several
    source files, expecting them to be used in multiple passes).

Note, these outcome names are not ideal, but they have to match the
requirements of the GCC test infrastructure that supports parallel
test execution.

The summary is reported in the form

``` none
        === acats Summary ===
# of expected passes		2499
# of unexpected failures	10
# of expected failures		1451
# of unresolved testcases	11
# of unsupported tests		106
*** FAILURES: cxd1003 cxd1004 cxd1005  cxd2006 cxd3001 cxd3002  cxh1001  c250002  c611a04  cxd4007
```
(this is from a run for GCC 8.0 on macOS).

[Ada-Auth]: http://www.ada-auth.org/acats.html
