#!/bin/bash

cd ..

echo ""
echo "==========================="
echo "example format lib"
echo "---------------------------"
cd example
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "flutter_example format lib"
echo "---------------------------"
cd flutter_example
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "kiwi format lib"
echo "---------------------------"
cd kiwi
echo "Nothing to generate here"
echo "==========================="
cd ..

echo ""
echo "==========================="
echo "kiwi_generator format lib"
echo "---------------------------"
cd kiwi_generator
flutter packages pub run build_runner build --delete-conflicting-outputs
echo "==========================="
cd ..
