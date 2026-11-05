/*-----------------------------------------------------------------*-C-*---
 * File:    %p%
 *
 *          Copyright (C)1997 Donovan Kolbly <d.kolbly@rscheme.org>
 *          as part of the RScheme project, licensed for free use.
 *          See <http://www.rscheme.org/> for the latest information.
 *
 * File version:     %I%
 * File mod date:    %E% %U%
 * System build:     %b%
 *
 *------------------------------------------------------------------------*/

#include "lgh.h"

int main( int argc, const char **argv )
{
  lgh_startup(0);
  lgh_eval( "(display \"Hello, RScheme-LGH\\n\")" );
  return 0;
}
