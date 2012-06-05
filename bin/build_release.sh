#!/bin/bash
#
# Modified by (ev) for Ooyala deploy process

RELEASE=`head -1 project.clj | awk '{print $3}' | sed -e 's/\"//' | sed -e 's/\"//'`

echo Making release $RELEASE

#DIR=_release/storm-$RELEASE
# Strip final number from release so we can easily overwrite checked in versions of Storm distro
RELEASE_NO_NUM=`echo $RELEASE | sed -e 's/[0-9]*$//'`
DIR=_release/$RELEASE_NO_NUM

rm -rf _release
export LEIN_ROOT=1
rm *.zip
rm *jar
rm -rf lib
rm -rf classes
lein deps
lein jar
mkdir -p $DIR
mkdir $DIR/lib
cp storm*jar $DIR/
cp lib/*.jar $DIR/lib
cp CHANGELOG.md $DIR/

echo $RELEASE > $DIR/RELEASE

cp -R log4j $DIR/
mkdir $DIR/logs

mkdir $DIR/conf
cp conf/storm.yaml.example $DIR/conf/storm.yaml

cp -R src/ui/public $DIR/

cp -R bin $DIR/

cp README.markdown $DIR/
cp LICENSE.html $DIR/

cd _release
zip -r storm-$RELEASE.zip *
cd ..
mv _release/storm-*.zip .
rm -rf _release

