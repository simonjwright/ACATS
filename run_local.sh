#!/bin/sh

# Run the whole suite (or just one chapter, in $1) using the installed
# compiler.
#
# Only tested on macOS.

testdir=`(cd $(dirname "$0"); pwd)`
export testdir
GCC=${GCC-`which gcc`}
export GCC
unset BASE
export BASE
EXPECT=${EXPECT-`which expect`}
export EXPECT

host_gnatchop=`which gnatchop`
host_gnatmake=`which gnatmake`

echo '#!/bin/sh' > host_gnatchop
echo PATH=`dirname $host_gnatchop`:'$PATH' >> host_gnatchop
echo unset ADA_INCLUDE_PATH ADA_OBJECTS_PATH GCC_EXEC_PREFIX >> host_gnatchop
echo export PATH >> host_gnatchop
echo exec gnatchop '"$@"' >> host_gnatchop

chmod +x host_gnatchop

echo '#!/bin/sh' > host_gnatmake
echo PATH=`dirname $host_gnatmake`:'$PATH' >> host_gnatmake
echo unset ADA_INCLUDE_PATH ADA_OBJECTS_PATH GCC_EXEC_PREFIX >> host_gnatmake
echo export PATH >> host_gnatmake
echo exec gnatmake '"$@"' >> host_gnatmake

chmod +x host_gnatmake

# Limit the stack to 16MB for stack checking
ulimit -s 16384

PATH=$PWD:$PATH
export PATH
exec $testdir/run_all.sh ${1+"$@"}
