env
obs_filename=`ls  ../../../../SOURCES/*.obs.tar.*`
my_release_version=`echo $obs_filename|sed -e "s/.*__Ver@//" -e "s/__.*//"`
# initial version automatically generated from release-process/scripts/mk_exim_release.pl
EXIM_RELEASE_VERSION=$my_release_version
EXIM_VARIANT_VERSION=
EXIM_COMPILE_NUMBER=0
