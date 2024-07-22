#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo ""
echo "dart_kiwi example package format lib"
cd examples/dart_kiwi
dart format .
cd ../..

echo ""
echo "flutter_kiwi example package format lib"
cd examples/flutter_kiwi
dart format .
cd ../..

echo ""
echo "kiwi final package format lib"
cd packages/kiwi
dart format .
cd ../..

echo ""
echo "kiwi_generator final package format lib"
cd packages/kiwi_generator
dart format .