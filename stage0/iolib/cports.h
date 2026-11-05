/**********************************************
THIS FILE WAS AUTOMATICALLY COPIED FROM THE
RSCHEME SOURCE TREE, AND THE ORIGINAL MAY CHANGE.
HENCE, DO NOT MODIFY THIS FILE BY HAND!
RScheme Build (Dev Build, 2026-11-04 19:40)
**********************************************/

#line 1 "../modules/iolib/cports.h"
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
 * Owned by module:  iolib
 *
 * Purpose:          Provide interface to C-implemented ports (string ports)
 *------------------------------------------------------------------------*/

#ifndef _H_CPORTS
#define _H_CPORTS

#include <string.h>

/* 
 * String Output Ports 
 */

obj SOP_flush( obj port, int closeq );
void SOP_write( obj port, const char *src, UINT_32 len );

#define SOP_BUFFER    SLOT(0)
#define SOP_INDEX     SLOT(1)
#define SOP_OVERFLOW  SLOT(2)


/* 
 *  Bounded-String Output Ports 
 */

rs_bool BSOP_write( obj port, const char *src, UINT_32 len );
obj BSOP_flush( obj port, int closeq );

#define BSOP_BUFFER    SLOT(0)
#define BSOP_INDEX     SLOT(1)


/* Output string conversion
 * 
 *  stores its results directly into REG0 and REG1
 */

extern void printablize_string( obj str, obj str_index );

/* Format string parsing
 */

obj parse_format_string( obj str );

#endif /* _H_CPORTS */
