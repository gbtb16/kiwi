#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

echo ""
echo "example format lib"
cd example
flutter packages pub global run dart_style:format -w lib
flutter packages pub global run dart_style:format -w test
cd ..

echo ""
echo "flutter_example format lib"
cd flutter_example
flutter packages pub global run dart_style:format -w lib
flutter packages pub global run dart_style:format -w test
cd ..

echo ""
echo "kiwi format lib"
cd kiwi
dart format -o none --set-exit-if-changed .
dart format -o none --set-exit-if-changed .
cd ..

echo ""
echo "kiwi_generator format lib"
cd kiwi_generator
dart format -o none --set-exit-if-changed .
dart format -o none --set-exit-if-changed .
cd ..
