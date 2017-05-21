# ACATS #

This repository contains a version of the
[Ada Conformity Assessment Test Suite][Ada-Auth] customised for use
with FSF GCC.

The current version is 4.1.

## Notes ##

To run the tests, you'll need `expect` (and `tcl`) installed.

### Testing in GCC ###

You can run the GCC checks with this version of the tests (provided you have `dejagnu` installed as well as `expect`) by replacing `gcc/testsuite/ada/acats` in the source tree by (a link to) this code and then, in the `gcc` directory of the build tree, run `make check-ada` (for these checks and the GNAT ones, or `make check-acats` for just these tests).

You can run the tests in parallel, which of course makes most sense if you have multiple cores, by for example `make -j4 check-acats`. If you do this, the screen output during execution is misleading; only `acats.log` and `acats.sum` are meaningful.

The standard GCC tests don't include any B or L tests (which are expected to fail). These tests can be run in local testing, see below.

### Local testing ###

You can also run the tests, or individual chapters of the tests, by using the `run_local.sh` script. For example,

    mkdir ~/tmp/acats
    cd ~/tmp/acats
    ~/ACATS/run_local.sh cxd cxe

will run just chapters CXD, CXE (execution tests on Annexes D and E).

The above command will only build the support code if it isn't already built. To force a rebuild, say

    ~/ACATS/run_local.sh NONE cxd cxe

### Reports ###

The reports are in `acats.log` and `acats.sum`.

`acats.log` is a full report of test compilation. build and execution.

`acats.sum` is a report of just the outcome of each test and a summary.

The outcomes are reported in the style `OUTCOME: test`, e.g. `PASS: a22006b`, where the possible outcomes are

  * `PASS`: the test passed
  * `FAIL`: the test was expected to pass but failed
  * `XFAIL`: the test was expected to fail and did so
  * `XPASS`: the test was expected to fail but passed
  * `UNRESOLVED`: the test requires visual examination to finally determine pass/fail
  * `UNSUPPORTED`: the test was either deemed not applicable by the test itself (for example, C45322A requires `Machine_Overflows` to be `True`) or not supported by the compiler (for example, CXAG002 will not compile because it requires support for `Hierarchical_File_Names`)

Note, these outcome names are not ideal, but they have to be chosen to match the requirements of the test infrastructure that supports parallel test execution.

The summary is reported in the form

            === acats Summary ===
    # of expected passes		2463
    # of unexpected failures	12
    # of expected failures		1
    # of unresolved testcases	11
    # of unsupported tests		45
    *** FAILURES: cxag001 cxd1003  c250002 c732b01 c732b02 c760015 cxd3001 cxd3002 cxh1001  cxd1004 cxd1005 cxd2006

(this is from a run for GCC 7.1.0 on macOS).


[Ada-Auth]: http://www.ada-auth.org/acats.html
