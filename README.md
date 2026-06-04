# Natural Order String Comparison for Lua
An advanced strnatcmp algorithm (natural order - natord) with fixed-point support for Lua

This repository contains an implementation of the algorithm based on [Natural Order String Comparison](https://github.com/sourcefrog/natsort) developed by [Martin Pool](https://github.com/sourcefrog) and the [natord](https://github.com/lifthrasiir/rust-natord), but it fixes a silly bug related to floating-point handling—this code treats `3` < `3.14159268` while the original algorithm and the [natord] library state that `3` > `3.14159268` lol


This serves to sort the Book list more accurately instead of the default, ridiculous sorting algorithm of the Koreader cover browser.


Please clearly credit the original algorithm author [Martin Pool](https://github.com/sourcefrog) and the advanced algorithm implementer [Tachibana Shin](https://github.com/tachibana-shin) in the source code, which is distributed under the [GNU GPL v3](./LICENSE) license.
