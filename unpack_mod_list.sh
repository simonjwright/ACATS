# Assuming you've unpacked the current mod list (say m) into ACATS/$m,
# change directory to ACATS/$m and execute this script to move the
# files into the appropriate place.

# l/ exists as well as lx?/, so do the lx? files first

for t in ../tests/lx* ../tests/*; do
    base=`basename $t`
    for f in ${base}*; do
        mv -v $f ../tests/${base}/
    done
done

mv -v * ../support/
