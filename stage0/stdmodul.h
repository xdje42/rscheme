#ifndef _H_RSCHEME_STDMODUL
#define _H_RSCHEME_STDMODUL

#include <rscheme/linktype.h>
extern struct module_descr module_bci;
extern struct module_descr module_rscheme;
extern struct module_descr module_editinp;
extern struct module_descr module_imageio;
extern struct module_descr module_sort;
extern struct module_descr module_regex;
extern struct module_descr module_iolib;
extern struct module_descr module_mathlib;
extern struct module_descr module_tables;
extern struct module_descr module_objsys;
extern struct module_descr module_low_scheme;
extern struct module_descr module_corelib;

#define STD_MODULES_DECL &module_bci, \
	&module_rscheme, \
	&module_editinp, \
	&module_imageio, \
	&module_sort, \
	&module_regex, \
	&module_iolib, \
	&module_mathlib, \
	&module_tables, \
	&module_objsys, \
	&module_low_scheme, \
	&module_corelib, (struct module_descr *)0
#endif /* _H_RSCHEME_STDMODUL */

