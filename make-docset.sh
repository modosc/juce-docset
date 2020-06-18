#!/bin/sh
set -e
set +x

if ! [ -x "$(xcode-select -print-path)/usr/bin/docsetutil" ]; then
  echo 'Error: docsetutil is not installed.' >&2
  echo 'Try: sudo ln -s /Applications/DocSetUtil/Developer/usr/bin/docsetutil  $(xcode-select -print-path)/usr/bin/docsetutil' >&2
  exit 1
fi

git submodule update --init
git submodule set-branch --branch juce-6 JUCE

rm -rf JUCE.docset
rm -rf JUCE.tgz

cd JUCE/docs/doxygen

# make sure to use python3 when building
sed -i.bak \
  -e 's/python /python3 /' \
  Makefile

make clean
doxygen -u
sed -i.bak \
  -e 's/.*GENERATE_DOCSET.*= NO.*/GENERATE_DOCSET = YES/' \
  -e 's/.*DISABLE_INDEX.*= NO.*/DISABLE_INDEX = YES/' \
  -e 's/.*SEARCHENGINE.*= YES.*/SEARCHENGINE = NO/' \
  -e 's/.*GENERATE_TREEVIEW.*= YES.*/GENERATE_TREEVIEW = NO/' \
  -e 's/.*HTML_HEADER.*=.*/HTML_HEADER = ..\/..\/..\/header.html/' \
  -e 's/.*DOCSET_BUNDLE_ID.*=.*/DOCSET_BUNDLE_ID = JUCE/' \
  -e 's/.*PROJECT_NAME.*=.*/PROJECT_NAME = "JUCE 6.0.0.preview2"/' \
  -e 's/.*PROJECT_NUMBER.*=.*/PROJECT_NUMBER = 6.0.0.preview2/' \
  -e 's/.*PAPER_TYPE.*=.*/PAPER_TYPE = a4/' \
  -e 's/.*MAX_DOT_GRAPH_DEPTH.*=.*/MAX_DOT_GRAPH_DEPTH = 0/' \
  -e 's/.*DOT_GRAPH_MAX_NODES.*=.*/DOT_GRAPH_MAX_NODES = 200/' \
  Doxyfile

make
cd doc
make
cp -r JUCE.docset ../../../../
cd ../../../..

iconPath=JUCE/extras/Projucer/Source/BinaryData/Icons/juce_icon.png
convert $iconPath -resize 16x16 JUCE.docset/Icon.png
convert $iconPath -resize 32x32 JUCE.docset/Icon@2x.png
plutil -replace DashDocSetFamily -string juce JUCE.docset/Contents/Info.plist
plutil -replace DocSetPlatformFamily -string juce JUCE.docset/Contents/Info.plist

tar --exclude='.DS_Store' -cvzf JUCE.tgz JUCE.docset

# do git cleanup
cd JUCE
git clean -f -d
git reset --hard origin/juce6