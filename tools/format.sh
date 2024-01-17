#!/bin/bash

CURRENT=`pwd`
DIR_NAME=`basename "$CURRENT"`
if [ $DIR_NAME == 'tools' ]
then
  cd ..
fi

echo ""
echo "example format lib"
cd example
dart format -o none --set-exit-if-changed .
cd ..

echo ""
echo "flutter_example format lib"
cd flutter_example
dart format -o none --set-exit-if-changed .
cd ..

echo ""
echo "kiwi format lib"
cd kiwi
dart format -o none --set-exit-if-changed .
cd ..

echo ""
echo "kiwi_generator format lib"
cd kiwi_generator
dart format -o none --set-exit-if-changed .
cd ..
