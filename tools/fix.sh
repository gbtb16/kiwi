#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo ""
echo "dart_kiwi example package fix lib"
cd examples/dart_kiwi
dart fix --apply
cd ../..

echo ""
echo "flutter_kiwi example package fix lib"
cd examples/flutter_kiwi
dart fix --apply
cd ../..

echo ""
echo "kiwi final package fix lib"
cd packages/kiwi
dart fix --apply
cd ../..

echo ""
echo "kiwi_generator final package fix lib"
cd packages/kiwi_generator
dart fix --apply