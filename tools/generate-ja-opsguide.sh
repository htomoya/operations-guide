#!/bin/bash

CONV_ONLY=True

GHPAGEDIR=$HOME/openstack-manuals-ja
TARGETDIR=openstack-ops-draft
#GHPAGEDIR=.

WORKBRANCH=trans-ja

CURDIR=$(pwd)
echo $CURDIR

if [ "$CONV_ONLY" != "True" ]; then
  git checkout $WORKBRANCH
fi

./tools/generatedocbook -l ja -b openstack-ops
cd generated/ja/openstack-ops/
sed -i 's/1.8.0/1.8.1-SNAPSHOT/' pom.xml
sed -i -e '/webhelpDirname/a\                            <webhelpIndexerLanguage>ja</webhelpIndexerLanguage>' pom.xml
mvn clean generate-sources
cd -

if [ "$CONV_ONLY" != "True" ]; then
  cd $GHPAGEDIR
  pwd
  git checkout gh-pages
  rm -rf $TARGETDIR/
  cp -pr $CURDIR/generated/ja/openstack-ops/target/docbkx/webhelp/local/openstack-ops $TARGETDIR
fi
