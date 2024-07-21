#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo ""
echo "dart_kiwi example package test"
cd examples/dart_kiwi
echo "No tests for dart_kiwi"
cd ../..

echo ""
echo "flutter_kiwi example package test"
cd examples/flutter_kiwi
echo "No test for flutter_kiwi"
cd ../..

echo ""
echo "kiwi final package test"
cd packages/kiwi
dart test
cd ../..

echo ""
echo "kiwi_generator final package test"
cd packages/kiwi_generator
dart test