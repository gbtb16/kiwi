#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo ""
echo "==========================="
echo "dart_kiwi example package analyze"
echo "---------------------------"
cd examples/dart_kiwi
flutter analyze
echo "==========================="
cd ../..

echo ""
echo "==========================="
echo "flutter_kiwi example package analyze"
echo "---------------------------"
cd examples/flutter_kiwi
flutter analyze
echo "==========================="
cd ../..

echo ""
echo "==========================="
echo "kiwi final package analyze"
echo "---------------------------"
cd packages/kiwi
dart analyze --fatal-infos --fatal-warnings .
echo "==========================="
cd ../..

echo ""
echo "==========================="
echo "kiwi_generator final package analyze"
echo "---------------------------"
cd packages/kiwi_generator
dart analyze --fatal-infos --fatal-warnings .
echo "==========================="