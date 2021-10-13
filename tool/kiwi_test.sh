#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tool' ]
then
  cd ..
fi

echo ""
echo "example test"
cd example
echo "No tests for example"
cd ..

echo ""
echo "flutter_example test"
cd flutter_example
echo "No test for flutter_example"
cd ..

echo ""
echo "kiwi test"
cd kiwi
flutter pub test
cd ..

echo ""
echo "kiwi_generator test"
cd kiwi_generator
flutter pub test
cd ..
