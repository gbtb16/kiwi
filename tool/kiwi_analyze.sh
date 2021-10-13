#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

echo ""
echo "==========================="
echo "example analyze"
echo "---------------------------"
cd example
flutter analyze
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "flutter_example analyze"
echo "---------------------------"
cd flutter_example
flutter analyze
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "kiwi analyze"
echo "---------------------------"
cd kiwi
flutter analyze
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "kiwi_generator analyze"
echo "---------------------------"
cd kiwi_generator
flutter analyze
echo "==========================="
cd ..
