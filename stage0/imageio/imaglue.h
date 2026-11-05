/**********************************************
THIS FILE WAS AUTOMATICALLY COPIED FROM THE
RSCHEME SOURCE TREE, AND THE ORIGINAL MAY CHANGE.
HENCE, DO NOT MODIFY THIS FILE BY HAND!
RScheme Build (Dev Build, 2026-11-04 19:40)
**********************************************/

#line 1 "../modules/imageio/imaglue.h"
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
 * Owned by module:  imageio
 *
 * Purpose:          image glue interface file
 *------------------------------------------------------------------------*/

#ifndef _H_IMAGEIO_IMAGGLUE
#define _H_IMAGEIO_IMAGGLUE

#include <rscheme/obj.h>

obj rs_compress( obj buffer_list );

obj rs_extract( UINT_8 *source, UINT_32 source_cnt );
obj rs_load_image( UINT_8 *source, UINT_32 source_cnt, obj refs );
obj rs_save_image( obj sections, obj marshall_table,
			      obj fix_slot_table, obj root );

obj parse_refs( obj class_table,
	        UINT_8 **srcp, unsigned src_cnt,
	        rs_bool do_link,
	        obj fdac, obj cpac, 
	        obj class_name_vec,
	        obj symbol_vec,
	        obj *miss_list );

#endif /* _H_IMAGEIO_IMAGGLUE */
