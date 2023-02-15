#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

echo ""
echo "==========================="
echo "example build_runner build"
echo "---------------------------"
cd example
dart pub run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "flutter_example build_runner build"
echo "---------------------------"
cd flutter_example
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "kiwi build_runner build"
echo "---------------------------"
cd kiwi
echo "Nothing to generate here"
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "kiwi_generator build_runner build"
echo "---------------------------"
cd kiwi_generator
dart pub run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ..
