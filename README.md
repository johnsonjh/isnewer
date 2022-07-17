<!-- vim: set nocp ts=2 sw=2 tw=78 colorcolumn=78 et nolist wrap lbr :-->
<!-- SPDX-License-Identifier: FSFAP -->
<!-- Copyright (c) 2022 Jeffrey H. Johnson <trnsz@pobox.com>
     Copying and distribution of this file, with or without modification,
     are permitted in any medium without royalty provided the copyright
     notice and this notice are preserved.  This file is offered "AS-IS",
     without any warranty. -->

# isnewer - compare file modification dates

A free implementation of AT&T Research UNIX V8 `newer(1)`.

## Overview

* It is unfortunately difficult to portably and robustly determine the
  newer of two files from a UNIX shell script; efforts to standardize
  this as part of POSIX
  [appear to have stalled](https://www.austingroupbugs.net/view.php?id=375).

* AT&T Research UNIX V8 (never released under a proper FLOSS license)
  provided this functionality via the `newer(1)` utility:

  ```
    NAME
         newer - test file modification dates

    SYNOPSIS
         newer file1 file2

    DESCRIPTION
         Newer yields a zero return code if file1 exists and file2
         does not, or if file1 and file2 both exist and file1's
         modification time is at least as recent as that of file2.
         It yields a non-zero return code otherwise.
  ```

* `isnewer` intends to be compatible with the AT&T Research UNIX V8
  `newer(1)` implementation, with the addition of supporting the
  following command-line arguments:

  * `-v` or `--version` - Prints version information to standard error
  * `-h` or `--help`    - Prints usage information to standard error

* These new arguments are exclusive; that is, they may not combined
  with each other and may not be used in conjunction with any date
  comparisons.

## Building

* `isnewer` should work on any POSIX-like system with a C compiler.
* A convenient `Makefile` for building and running tests is provided.

## Notes

* No effort is made to utilize sub-second mtime precision
* [mtime comparison considered harmful](https://apenwarr.ca/log/20181113)
  (according to some people)

## License

* `isnewer` is distributed under the terms and conditions of the
  following Zero-Clause BSD (*0BSD*) license.

  ```
  Copyright (c) 2022 Jeffrey H. Johnson <trnsz@pobox.com>

  Permission to use, copy, modify, and/or distribute this software for
  any purpose with or without fee is hereby granted.

  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  ```
