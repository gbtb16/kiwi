#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo "dart_kiwi example package packages get"
cd examples/dart_kiwi
flutter packages get
cd ../..

echo "flutter_kiwi example package packages get"
cd examples/flutter_kiwi
flutter packages get
cd ../..

echo "kiwi final package packages get"
cd packages/kiwi
dart pub get
cd ../..

echo "kiwi_generator final package packages get"
cd packages/kiwi_generator
dart pub get
cd ../..

echo "actions packages get"
cd tools/kiwi_cli_actions
dart pub get