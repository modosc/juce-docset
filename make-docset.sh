#!/bin/sh
set -e
set +x

if ! [ -x "$(xcode-select -print-path)/usr/bin/docsetutil" ]; then
  echo 'Error: docsetutil is not installed.' >&2
  echo 'Try: sudo ln -s /Applications/DocSetUtil/Developer/usr/bin/docsetutil  $(xcode-select -print-path)/usr/bin/docsetutil' >&2
  exit 1
fi

git submodule update --init

git reset --hard origin/juce6

rm -rf JUCE.docset
rm -rf JUCE.tgz

cd JUCE/doxygen

# make sure to use python3 when building
sed -i.bak \
  -e 's/python /python3 /' \
  Makefile

make clean
sed -i.bak \
  -e 's/.*GENERATE_DOCSET.*= NO.*/GENERATE_DOCSET = YES/' \
  -e 's/.*DISABLE_INDEX.*= NO.*/DISABLE_INDEX = YES/' \
  -e 's/.*SEARCHENGINE.*= YES.*/SEARCHENGINE = NO/' \
  -e 's/.*GENERATE_TREEVIEW.*= YES.*/GENERATE_TREEVIEW = NO/' \
  -e 's/.*HTML_HEADER.*=.*/HTML_HEADER = ..\/..\/header.html/' \
  -e 's/.*DOCSET_BUNDLE_ID.*=.*/DOCSET_BUNDLE_ID = JUCE/' \
  Doxyfile
make
cd doc
make
cp -r JUCE.docset ../../../
cd ../../..

mv JUCE.docset JUCE6.docset
iconPath=JUCE/extras/Projucer/Source/BinaryData/Icons/juce_icon.png
convert $iconPath -resize 16x16 JUCE6.docset/Icon.png
convert $iconPath -resize 32x32 JUCE6.docset/Icon@2x.png

tar --exclude='.DS_Store' -cvzf JUCE6.tgz JUCE6.docset

# do git cleanup
cd JUCE
git clean -f -d
git reset --hard origin/juce6