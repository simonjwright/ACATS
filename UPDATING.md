# Updating the repository #

There are three branches:

* `acats-4.1` contains the original 4.1 source code from the [ACATS website][Ada-Auth] (reorganised to match the GCC test suite layout),
* `acats-4.2` contains the original 4.2 source code,
* `master` contains the same, with minor changes and with scripts and other data to support running in the GCC context.

Obtain the updated test data (e.g. `mod_4_2a.tar.Z`) and the documentation (e.g. `mod-list-4.2a.txt`) from the [ACATS website][Ada-Auth].

Switch to the `acats-4.2` branch.

Create a new directory for the updated test data (e.g. `a/`) and change directory into it.

Unpack the archive, e.g. `tar zxvf /where/ever/mod_4_2a.tar.Z`.

The files in the archive are stored in a flat structure: move them to the appropriate place in the GCC structure by `../unpack_mod_list.sh` (there should be no files left: if any were included in the archive in error, they will be in `../support/`).

Change directory back to the top level.

Check the documentation; if there are any removed tests, delete them. This isn't always obvious: start at the section "Changes from the last list". For confirmation, check in the "Main list" for lines with the `Org VCS Label` set to (e.g.) `A4_2A` and marked `Withdrawn`. (There were none in this modification list).

Mark the changes:
```
git add tests/ support/
```
(you may prefer to be more circumspect!) and commit, e.g.:
```
git commit -m 'Updated to ACATS 4.2A.'
```
and push.
```
git push
```
Now,

* switch to the `master` branch and merge the `acats-4.2` branch (you may be able to cherry-pick the commit just made in the other branch);
* update `README.md` and commit the change;
* tag the release, e.g. `tag -s -m 'Tagging acats-4.2a' acats-4.2a`
* `push`, and `push --tags`.

[Ada-Auth]: http://www.ada-auth.org/acats.html
