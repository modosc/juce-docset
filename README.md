# juce-docset

## About

A docset generator script for the [JUCE](https://github.com/WeAreROLI/JUCE)
library.

The docset is available
[here](https://github.com/Kapeli/Dash-User-Contributions/tree/master/docsets/JUCE)
as a user-contributed docset for [Dash](https://kapeli.com/dash).

## Dependencies

- Doxygen
- ImageMagick
- `docesetutil` is required but no longer shipped with `XCode`. To make this work download the archive from [here](https://github.com/Kapeli/Dash-User-Contributions/pull/1884#issuecomment-389793784) and then symlink the `docsetutil` binary, ie:
```bash
$ sudo ln -s docsetutil $(xcode-select -print-path)/usr/bin/`
```
## Usage

- Run `./make-docset.sh`.
- The resulting docset will appear in `JUCE.docset`.
