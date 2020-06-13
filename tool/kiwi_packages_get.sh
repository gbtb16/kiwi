#!/bin/bash

cd ..

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
flutter packages get
cd ..

echo "kiwi_generator packages get"
cd kiwi_generator
flutter packages get
cd ..
