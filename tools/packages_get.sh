#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo "example packages get"
cd example
flutter packages get
cd ..

echo "flutter_example packages get"
cd flutter_example
flutter packages get
cd ..

echo "kiwi packages get"
cd kiwi
dart pub get
cd ..

echo "kiwi_generator packages get"
cd kiwi_generator
dart pub get
cd ..

echo "actions packages get"
cd tools/actions
dart pub get
cd ..
