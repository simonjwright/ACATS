#!/bin/sh
# Run ACATS with the GNU Ada compiler

# The following functions are to be customized if you run in cross
# environment or want to change compilation flags.  Note that for
# tests requiring checks not turned on by default, this script
# automatically adds the needed flags to pass (ie: -gnato or -gnatE).

# gccflags="-O3 -fomit-frame-pointer -funroll-all-loops -finline-functions"
# gnatflags="-gnatN"

gccflags="-O2"
gnatflags="-gnatws"

# End of customization section.

# Perform arithmetic evaluation on the ARGs, and store the result in the
# global $as_val. Take advantage of shells that can avoid forks. The arguments
# must be portable across $(()) and expr.
if (eval "test \$(( 1 + 1 )) = 2") 2>/dev/null; then :
  eval 'as_fn_arith ()
  {
    as_val=$(( $* ))
  }'
else
  as_fn_arith ()
  {
    as_val=`expr "$@" || test $? -eq 1`
  }
fi # as_fn_arith

display_noeol () {
  printf "$@"
  printf "$@" >> $dir/acats.sum
  printf "$@" >> $dir/acats.log
}

display () {
  echo "$@"
  echo "$@" >> $dir/acats.sum
  echo "$@" >> $dir/acats.log
}

log () {
  echo "$@" >> $dir/acats.sum
  echo "$@" >> $dir/acats.log
}

dir=`${PWDCMD-pwd}`

if [ "$dir" = "$testdir" ]; then
  echo "error: srcdir must be different than objdir, exiting."
  exit 1
fi

if [ "$BASE" ]; then
  GCC="$BASE/xgcc -B$BASE/"
else
  GCC="${GCC-`which gcc`}"
fi

target_gnatchop () {
  if [ "$BASE" ]; then
    $BASE/gnatchop --GCC="$BASE/xgcc" $*
  else
    host_gnatchop $*
  fi
}

target_gnatmake () {
  if [ "$BASE" ]; then
    echo $BASE/gnatmake --GNATBIND=$BASE/gnatbind --GNATLINK=$BASE/gnatlink --GCC="$GCC" $gnatflags $gccflags $* -largs $EXTERNAL_OBJECTS --GCC="$GCC"
    $BASE/gnatmake --GNATBIND=$BASE/gnatbind --GNATLINK=$BASE/gnatlink --GCC="$GCC" $gnatflags $gccflags $* -largs $EXTERNAL_OBJECTS --GCC="$GCC"
  else
    echo gnatmake $gnatflags $gccflags $* -largs $EXTERNAL_OBJECTS
    host_gnatmake $gnatflags $gccflags $* -largs $EXTERNAL_OBJECTS
  fi
}

target_gcc () {
  $GCC $gccflags $*
}

target_run () {
  eval $EXPECT -f $testdir/run_test.exp $*
}

clean_dir () {
  rm -f "$binmain" *.o *.ali > /dev/null 2>&1
}

find_main () {
  # Must handle the cases that aren't correctly identified (ACATS 4.1)
  # $1 is the test
  case ${1} in
     c3a1003)
       main=c3a10032
       ;;
     c3a1004)
       main=c3a10042
       ;;
     ca11023)
       main=ca110232
       ;;
     *)
       ls ${1}?.adb > ${1}.lst 2> /dev/null
       ls ${1}*m.adb >> ${1}.lst 2> /dev/null
       ls ${1}.adb >> ${1}.lst 2> /dev/null
       main=`tail -1 ${1}.lst`
       ;;
  esac
}

handle_pass () {
  # check that a pass for test $1 wasn't supposed to fail
  grep ${1} $testdir/xfail.lst >/dev/null 2>&1
  inlist=$?
  echo ${1} | egrep '^[bl]' >/dev/null 2>&1
  b_or_l=$?
  if [ $inlist -ne 0 -a $b_or_l -ne 0 ]; then
    # OK to have passed
    log "PASS:	$1"
    as_fn_arith $glob_countok + 1
    glob_countok=$as_val
  else
    # should have failed
    log "XPASS:	$1"
    as_fn_arith $glob_countxp + 1
    glob_countxp=$as_val
  fi
}

handle_fail () {
  # check that a fail for test $1 wasn't supposed to pass
  grep ${1} $testdir/xfail.lst >/dev/null 2>&1
  inlist=$?
  echo ${1} | egrep '^[bl]' >/dev/null 2>&1
  b_or_l=$?
  if [ $inlist -eq 0 -o $b_or_l -eq 0 ]; then
    # OK to have failed
    log "XFAIL:	$1"
    as_fn_arith $glob_countxf + 1
    glob_countxf=$as_val
  else
    # should have passed
    display "FAIL:	$1"
    as_fn_arith $glob_countf + 1
    glob_countf=$as_val
    failed="${failed}${tst} "
  fi
}

run_one_test () {
  tst=$1

  extraflags="-gnat2012"
  grep $tst $testdir/overflow.lst > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    extraflags="$extraflags -gnato"
  fi
  grep $tst $testdir/elabd.lst > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    extraflags="$extraflags -gnatE"
  fi
  grep $tst $testdir/floatstore.lst > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    extraflags="$extraflags -ffloat-store"
  fi
  grep $tst $testdir/stackcheck.lst > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    extraflags="$extraflags -fstack-check"
  fi
  test=$dir/tests/$chapter/$tst
  rm -rf $test
  mkdir $test && cd $test >> $dir/acats.log 2>&1

  if [ $? -ne 0 ]; then
    handle_fail $tst
    clean_dir
    return
  fi

  target_gnatchop -c -w `ls ${test}*.a ${test}*.ada ${test}*.au ${test}*.adt ${test}*.am ${test}*.dep 2> /dev/null` >> $dir/acats.log 2>&1
  main=""
  find_main $i
  if [ -z "$main" ]; then
    sync
    find_main $i
  fi
  binmain=`echo $main | sed -e 's/\(.*\)\..*/\1/g'`
  echo "BUILD $main" >> $dir/acats.log
  case $tst in
    cxb3004) EXTERNAL_OBJECTS="$dir_support/cxb30040.o";;
    cxb3006) EXTERNAL_OBJECTS="$dir_support/cxb30060.o";;
    cxb3013) EXTERNAL_OBJECTS="$dir_support/cxb30130.o $dir_support/cxb30131.o";;
    cxb3017) EXTERNAL_OBJECTS="$dir_support/cxb30170.o";;
    cxb3018) EXTERNAL_OBJECTS="$dir_support/cxb30180.o";;
    *)       EXTERNAL_OBJECTS="";;
  esac
  if [ "$main" = "" ]; then
    handle_fail $tst
    clean_dir
    return
  fi

  target_gnatmake $extraflags -I$dir_support $main \
                  > $dir/tests/$chapter/${tst}/${tst}.log 2>&1
  compilation_status=$?
  cat $dir/tests/$chapter/${tst}/${tst}.log >> $dir/acats.log
  if [ $compilation_status -ne 0 ]; then
    grep 'not supported in this configuration' \
         $dir/tests/$chapter/${tst}/${tst}.log > /dev/null 2>&1
    if [ $? -eq 0 ]; then
      log "UNSUPPORTED:	$tst"
      as_fn_arith $glob_countu + 1
      glob_countu=$as_val
    else
      handle_fail $tst
    fi
    clean_dir
    return
  fi

  echo "RUN $binmain" >> $dir/acats.log
  cd $dir/run
  if [ ! -x $dir/tests/$chapter/$tst/$binmain ]; then
    sync
  fi
  target_run $dir/tests/$chapter/$tst/$binmain > $dir/tests/$chapter/$tst/${tst}.log 2>&1
  cd $dir/tests/$chapter/$tst
  cat ${tst}.log >> $dir/acats.log

  # check for a status report from execution
  status=`egrep -e '(==== |\+\+\+\+ |\!\!\!\! )' ${tst}.log`
  if [ $? -ne 0 ]; then
    grep 'tasking not implemented' ${tst}.log > /dev/null 2>&1

    if [ $? -ne 0 ]; then
      handle_fail $tst
    else
      log "UNSUPPORTED:	$tst"
      as_fn_arith $glob_countu + 1
      glob_countu=$as_val
    fi
  else
    case `echo $status | cut -c1-4` in
      "====")
        handle_pass $tst;;
      "++++")
        log "UNSUPPORTED:	$tst"
        as_fn_arith $glob_countna + 1
        glob_countna=$as_val;;
      "!!!!")
        log "UNRESOLVED:	$tst"
        as_fn_arith $glob_counti + 1
        glob_counti=$as_val;;
      *)
        log "ERROR:	$tst"
        as_fn_arith $glob_counti + 1
        glob_counti=$as_val;;
    esac
  fi
  clean_dir
}

EXTERNAL_OBJECTS=""
# Global variable to communicate external objects to link with.

rm -f $dir/acats.sum $dir/acats.log

display "Test Run By $USER on `date`"

display "		=== acats configuration ==="

target=`$GCC -dumpmachine`

display target gcc is $GCC
display `$GCC -v 2>&1`
display host=`gcc -dumpmachine`
display target=$target
display `type gnatmake`
gnatls -v >> $dir/acats.log
display ""

if [ -n "$GCC_RUNTEST_PARALLELIZE_DIR" ]; then
  dir_support=$dir/../acats/support

  rm -rf $dir/run
  mv $dir/tests $dir/tests.$$ 2> /dev/null
  rm -rf $dir/tests.$$ &
  mkdir -p $dir/run

  cp -pr $dir/../acats/tests $dir/
else
  dir_support=$dir/support

  # Only build support if needed
  if [ ! -d $dir_support ] || [ $# -eq 0 ] || [ $1 = "NONE" ]; then

    display "		=== acats support ==="
    display_noeol "Generating support files..."

    rm -rf $dir/support
    mkdir -p $dir/support
    cd $dir/support

    cp $testdir/support/*.ada $testdir/support/*.a $testdir/support/*.tst $dir/support

    # Find out the size in bit of an address on the target
    target_gnatmake $testdir/support/impbit.adb >> $dir/acats.log 2>&1
    if [ $? -ne 0 ]; then
      display "**** Failed to compile impbit"
      exit 1
    fi
    target_run $dir/support/impbit > $dir/support/impbit.out 2>&1
    target_bit=`cat $dir/support/impbit.out`
    echo target_bit="$target_bit" >> $dir/acats.log

    # Find out a suitable asm statement
    # Adapted from configure.ac gcc_cv_as_dwarf2_debug_line
    case "$target" in
      ia64*-*-* | s390*-*-*)
        target_insn="nop 0"
        ;;
      mmix-*-*)
        target_insn="swym 0"
        ;;
      *)
        target_insn="nop"
        ;;
    esac
    echo target_insn="$target_insn" >> $dir/acats.log

    sed -e "s,ACATS4GNATDIR,$dir,g" \
        < $testdir/support/impdef.a > $dir/support/impdef.a
    sed -e "s,ACATS4GNATDIR,$dir,g" \
        < $testdir/support/impdefc.a > $dir/support/impdefc.a
    sed -e "s,ACATS4GNATDIR,$dir,g" \
        -e "s,ACATS4GNATBIT,$target_bit,g" \
        -e "s,ACATS4GNATINSN,$target_insn,g" \
        < $testdir/support/macro.dfs > $dir/support/MACRO.DFS
    sed -e "s,ACATS4GNATDIR,$dir,g" \
        < $testdir/support/tsttests.dat > $dir/support/TSTTESTS.DAT

    cp $testdir/tests/cd/*.c $dir/support
    cp $testdir/tests/cxb/*.c $dir/support
    grep -v '^#' $testdir/norun.lst | sort > $dir/support/norun.lst

    rm -rf $dir/run
    mv $dir/tests $dir/tests.$$ 2> /dev/null
    rm -rf $dir/tests.$$ &
    mkdir -p $dir/run

    cp -pr $testdir/tests $dir/

    for i in $dir/support/*.ada $dir/support/*.a; do
      host_gnatchop $i >> $dir/acats.log 2>&1
    done

    # These tools are used to preprocess some ACATS sources.
    # They need to be compiled native on the host.

    host_gnatmake -q -gnatws macrosub.adb
    if [ $? -ne 0 ]; then
      display "**** Failed to compile macrosub"
      exit 1
    fi
    ./macrosub >> $dir/acats.log 2>&1

    rm -f $dir/support/macrosub
    rm -f $dir/support/*.ali
    rm -f $dir/support/*.o

    display " done."

    # From here, all compilations will be made by the target compiler

    display_noeol "Compiling support files..."

    # This program is used to support Annex C tests via impdefc.a.
    target_gnatmake $testdir/support/send_sigint_to_parent.adb \
                    >> $dir/acats.log 2>&1
    if [ $? -ne 0 ]; then
      display "**** Failed to compile send_sigint_to_parent"
      exit 1
    fi

    target_gcc -c *.c >> $dir/acats.log 2>&1
    if [ $? -ne 0 ]; then
      display "**** Failed to compile C code"
      exit 1
    fi

    target_gnatchop *.adt >> $dir/acats.log 2>&1

    target_gnatmake -c -gnato -gnatE *.ads >> $dir/acats.log 2>&1
    target_gnatmake -c -gnato -gnatE *.adb >> $dir/acats.log 2>&1

    display " done."
    display ""

  fi
fi

display "		=== acats tests ==="

if [ $# -eq 0 ]; then
   # only run the tests that are supposed to succeed, omitting cxe
   # (Annex E is the Distributed Systems annex, not straightforward to
   # script here)
   chapters=`cd $dir/tests; echo cz a* c[^z] cx[^e] d* e*`
else
   chapters=$*
fi

# number of passed tests
glob_countok=0

# number of tests that should be inspected
glob_counti=0

# number of unsupported tests, as reported by the compiler
glob_countu=0

# number of not-applicable tests, as determined by running the test.
glob_countna=0

# number of failures
glob_countf=0

# number of expected failures
glob_countxf=0

# number of unexpected passes
glob_countxp=0

# These for possible parallel execution, see below
par_count=0
par_countm=0
par_last=

for chapter in $chapters; do
   # Used to generate support once and finish after that.
   [ "$chapter" = "NONE" ] && continue

   display Running chapter $chapter ...

   if [ ! -d $dir/tests/$chapter ]; then
      display "*** CHAPTER $chapter does not exist, skipping."
      display ""
      continue
   fi

   cd $dir/tests/$chapter
   ls *.a *.ada *.adt *.am *.au *.dep 2> /dev/null | \
       sed -e 's/\(.*\)\..*/\1/g' | \
       cut -c1-7 | sort | uniq | comm -23 - $dir_support/norun.lst \
       > $dir/tests/$chapter/${chapter}.lst

   for i in `cat $dir/tests/$chapter/${chapter}.lst`; do

      # If running multiple run_all.sh jobs in parallel, decide
      # if we should run this test in the current instance.
      if [ -n "$GCC_RUNTEST_PARALLELIZE_DIR" ]; then
	 case "$i" in
	    # Ugh, some tests have inter-test dependencies, those
	    # tests have to be scheduled on the same parallel instance
	    # as previous test.
	    ce2108f | ce2108h | ce3112d) ;;
	    # All others can be hopefully scheduled freely.
	    *)
	       as_fn_arith $par_countm + 1
	       par_countm=$as_val
	       [ $par_countm -eq 10 ] && par_countm=0
	       if [ $par_countm -eq 1 ]; then
		  as_fn_arith $par_count + 1
		  par_count=$as_val
		  if mkdir $GCC_RUNTEST_PARALLELIZE_DIR/$par_count 2>/dev/null; then
		     par_last=1
		  else
		     par_last=
		  fi
	       fi;;
	 esac
	 if [ -z "$par_last" ]; then
	    continue
	 fi
      fi

      run_one_test $i

   done
done

display "		=== acats Summary ==="
# text must be as expected by contrib/dg-extract-results.py (including
# tabs)
display "# of expected passes		$glob_countok"
display "# of unexpected failures	$glob_countf"
if [ $glob_countxf -ne 0 ]; then
  display "# of expected failures		$glob_countxf"
fi
if [ $glob_countxp -ne 0 ]; then
  display "# of unexpected successes	$glob_countxp"
fi
# preparing output for standard run; must only use names supported
# by contrib/dg-extract-results.py
if [ $glob_counti -ne 0 ]; then
  display "# of unresolved testcases	$glob_counti"
fi
as_fn_arith $glob_countu + $glob_countna
unsupported=$as_val
if [ $unsupported -ne 0 ]; then
  display "# of unsupported tests		$unsupported"
fi

if [ $glob_countf -ne 0 ]; then
   display "*** FAILURES: $failed"
fi

display "$0 completed at `date`"

exit 0

# for Emacs
# Local Variables:
# sh-indentation: 2
# sh-basic-offset: 2
# End:
