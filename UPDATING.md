# Updating the repository #

There are two branches:

* `acats-4.1` contains the original source code from the [ACATS website][Ada-Auth] (reorganised to match the GCC test suite layout)
* `master` contains the same, with minor changes and with scripts and other data to support running in the GCC context.

Obtain the updated test data (e.g. `mod_4_1bb.tar.Z`) and the documentation (e.g. `mod-list-4.1bb.txt`) from the [ACATS website][Ada-Auth].

Switch to the `acats-4.1` branch.

Create a new directory for the updated test data (e.g. `bb/`) and change directory into it.

Unpack the archive, e.g. `tar zxvf /where/ever/mod_4_1bb.tar.Z`.

The files in the archive are stored in a flat structure: move them to the appropriate place in the GCC structure by `../unpack_mod_list.sh` (there should be no files left: if any were included in the archive in error, they will be in `../support/`).

Change directory back to the top level.

Check the documentation; if there are any removed tests, delete them. This isn't always obvious: start at the section "Changes from the last list". For confirmation, check in the "Main list" for lines with the `Org VCS Label` set to (e.g.) `A4_1BB` and marked `Withdrawn`. (There were none in this modification list).

Mark the changes:
```
git add tests/ support/
```
(you may prefer to be more circumspect!) and commit, e.g.:
```
git commit -m 'Updated to ACATS 4.1BB.'
```
and push.
```
git push
```
Now,

* switch to the `master` branch and merge the `acats-4.1` branch (you may be able to cherry-pick the commit just made in the other branch);
* update `README.md` and commit the change;
* tag the release, e.g. `tag -s -m 'Tagging acats-4.1bb' acats-4.1bb`
* `push`, and `push --tags`.

[Ada-Auth]: http://www.ada-auth.org/acats.html
