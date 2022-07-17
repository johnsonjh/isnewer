/*
 * vim: set ft=c ts=2 sw=2 tw=78 expandtab colorcolumn=78 spell :
 * SPDX-License-Identifier: 0BSD
 *
 * ---------------------------------------------------------------------------
 *
 * isnewer - Reimplementation of AT&T Research UNIX V8 newer(1)
 *
 * Copyright (c) 2022 Jeffrey H. Johnson <trnsz@pobox.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for
 * any purpose with or without fee is hereby granted.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 * ---------------------------------------------------------------------------
 *
 * AT&T Research UNIX V8 newer(1) documentation:
 *
 *   NAME
 *        newer - test file modification dates
 *
 *   SYNOPSIS
 *        newer file1 file2
 *
 *   DESCRIPTION
 *        Newer yields a zero return code if file1 exists and file2
 *        does not, or if file1 and file2 both exist and file1's modi-
 *        fication time is at least as recent as that of file2. It
 *        yields a non-zero return code otherwise.
 *
 * ---------------------------------------------------------------------------
 *
 * isnewer intends to be compatible with AT&T Research UNIX V8 newer(1)
 * usage, but adds support for the following command-line arguments:
 *
 *   `-v` or `--version` - Prints version information to standard error
 *   `-h` or `--help`    - Prints usage information to standard error
 *
 * These new arguments are exclusive; that is, they may not combined with
 * each other, and may not be used in conjunction with a date comparison.
 *
 * ---------------------------------------------------------------------------
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>

#ifdef ISNEWER_VER
# undef ISNEWER_VER
#endif /* ifdef ISNEWER_VER */
#define ISNEWER_VER "isnewer version 1.0"

#ifdef ISNEWER_USE
# undef ISNEWER_USE
#endif /* ifdef ISNEWER_USE */
#define ISNEWER_USE "Usage: isnewer file1 file2"

#ifndef EXIT_FAILURE
# define EXIT_FAILURE 1
#endif /* ifndef EXIT_FAILURE */

#ifndef EXIT_SUCCESS
# define EXIT_SUCCEESS 0
#endif /* ifndef EXIT_SUCCESS */

int
#ifndef __STDC__
main (argc, argv)
  int argc;
  char **argv;
#else
main (int argc, char **argv)
#endif /* ifndef __STDC__ */
{
  struct stat file1, file2;

  if ( ( argc > 3 ) ||
       ( argc < 2 ))
    {
      return ( EXIT_FAILURE );
    }
  else if ( argc == 2 )
    {
      if ( ( !( strcmp( argv [1], "-v" ) ) ) ||
           ( !( strcmp( argv [1], "--version" ) ) ))
        {
          fprintf(stderr, "%s\n", ISNEWER_VER);
          return ( EXIT_FAILURE );
        }
      else if ( ( !( strcmp( argv [1], "-h" ) ) ) ||
                ( !( strcmp( argv [1], "--help" ) ) ))
        {
          fprintf(stderr, "%s\n", ISNEWER_USE);
          return ( EXIT_FAILURE );
        }
      return ( EXIT_FAILURE );
    }

  if ( ( stat( argv [1], &file1 ) < 0 ) )
    {
      return ( EXIT_FAILURE );
    }

  if ( ( stat( argv [2], &file2 ) < 0 ) )
    {
      return ( EXIT_SUCCESS );
    }

  if ( file1.st_mtime < file2.st_mtime )
    {
      return ( EXIT_FAILURE );
    }

  return ( EXIT_SUCCESS );
}
