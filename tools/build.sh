#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo ""
echo "==========================="
echo "dart_kiwi example package build_runner build"
echo "---------------------------"
cd examples/dart_kiwi
dart run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ../..

echo ""
echo "==========================="
echo "flutter_kiwi example package build_runner build"
echo "---------------------------"
cd examples/flutter_kiwi
dart run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ../..

echo ""
echo "==========================="
echo "kiwi final package build_runner build"
echo "---------------------------"
cd packages/kiwi
echo "Nothing to generate here"
echo "==========================="
cd ../..

echo ""
echo "==========================="
echo "kiwi_generator final package build_runner build"
echo "---------------------------"
cd packages/kiwi_generator
dart run build_runner build --delete-conflicting-outputs
echo "==========================="