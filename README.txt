
== Dependencies ==

 * almost none for "automatic" build...
 * but, you do need:
  * `bash`, `coreutils`;
  * `tar`, `wget`;
 * supported distributions:
  * `mos`;
  * `debian` / `ubuntu`;
  * any other for which you manually install the needed packages;
 * if you don't have a "supported" distribution, you need (the list is not exhaustive):
  * `gcc` / `g++` (4.x);
  * `java` (1.7);
  * `erlang` (r15);
  * `nodejs` (0.6);

== Preparing ==

 * if you are running `mos`:
~~~~
( set -e -E -C -u -o pipefail || exit 1
_dependencies=(
	
	# put here the packages listed in
	# `./scripts/prepare-workbench-env-mos.bash`
	# under the section `Slitaz generic packages`
	# and the section `Slitaz miscellaneous packages`
	
	# Slitaz generic packages
		coreutils coreutils-character coreutils-command
		coreutils-conditions coreutils-context-system
		coreutils-context-user coreutils-context-working
		coreutils-directory coreutils-file-attributes
		coreutils-file-format coreutils-file-output-full
		coreutils-file-output-part coreutils-file-sort
		coreutils-file-special coreutils-file-summarize
		coreutils-line coreutils-numeric coreutils-path
		coreutils-redirection
		findutils grep sed gawk
	# Slitaz miscellaneous packages
		perl python git tar zip wget curl
)
for _dependency in "${_dependencies[@]}" ; do
	tazpkg get-install "${_dependency}"
done
)
~~~~

 * if you are running `Ubuntu` (12.04):
~~~~
( set -e -E -C -u -o pipefail || exit 1
_dependencies=(
		git
)
for _dependency in "${_dependencies[@]}" ; do
	yes | apt-get install -y "${_dependency}"
done
)
~~~~

 * if you have `git` (recommended):
~~~~
git clone -b r0.2 git://github.com/cipriancraciun/mosaic-distribution.git ./mosaic-distribution
~~~~
 * to update, inside the `mosaic-distribution` folder:
~~~~
git pull
~~~~

 * if you don't have `git`:
  * but you do need GNU `tar` (the `busybox` one doesn't work);
~~~~
( set -e -E -C -u -o pipefail || exit 1
mkdir ./mosaic-distribution
cd ./mosaic-distribution
wget -O - http://nodeload.github.com/cipriancraciun/mosaic-distribution/tarball/r0.2 \
| tar -xz --strip-components 1
)
~~~~

== Building ==

 * inside the `mosaic-distribution` folder:
~~~~
( set -e -E -C -u -o pipefail || exit 1
./scripts/prepare-all
./scripts/compile-all
./scripts/package-all
)
~~~~

== Deploying ==

 * we assume that you'we configured a "default" private key for the host `agent-1.builder.mosaic.ieat.ro`;
 * inside the `mosaic-distribution` folder:
~~~~
( set -e -E -C -u -o pipefail || exit 1
./scripts/deploy-all
)
~~~~
