# juce-docset

## About

A docset generator script for the [JUCE](https://github.com/WeAreROLI/JUCE)
library.

The docset is available
[here](https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets/JUCE)
as a user-contributed docset for [Dash](https://kapeli.com/dash).

## Dependencies

- Doxygen
```bash
$ brew install doxygen
```
- ImageMagick
```bash
$ brew install imagemagick
```
- `docesetutil` is required but no longer shipped with `XCode`. To make this work download the archive from [here](https://github.com/Kapeli/Dash-User-Contributions/pull/1884#issuecomment-389793784), put it in `/Applications`, and then symlink the `docsetutil` binary, ie:
```bash
$ cd $(xcode-select -print-path)/usr/bin/
$ sudo ln -s /Applications/DocSetUtil/Developer/usr/bin/docsetutil
```
## Usage

- Run `./make-docset.sh`.
- The resulting docset will appear in `JUCE.docset`.
