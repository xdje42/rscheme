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
 * Purpose:          function to locate system image
 *------------------------------------------------------------------------*/

#include <rscheme/osglue.h>
#include <rscheme/rlseconf.h>
#include <rscheme/scheme.h>
#include <rscheme/api.h>

#include <string.h>
#include <ctype.h>
#ifdef __NeXT__
#include <mach/mach.h>
#endif

// Working directory for various attempts.
static char image_path[1024];

// Given argv0 of foo/bar/baz, try foo/resource/${base}.img.
// Result is non-zero on success, with the path stored in image_path.

static int try_image(const char *arg0, const char *new_base)
{
  const char *base = strrchr(arg0, '/');
  char *p;
  if (base == NULL)
    return 0;

  strncpy(image_path, arg0, base - arg0);
  image_path[base - arg0] = 0;

  p = strrchr(image_path, '/');
  if (p)
    p[1] = 0;

  strcat(image_path, "resource/");
  strcat(image_path, new_base);
  strcat(image_path, ".img");

  return os_file_exists_p(image_path);
}

// Try to locate the system image if it wasn't specified on the command line.
//
// FIXME: The order in which paths are tried needs revisiting.

const char *find_system_image( const char *arg0, const char *dflt )
{
const char *base;
char *p;
#ifdef __NeXT__
int n;

   if (getsectdata( "IMAGE", "system", &n ))
     {
       return "sect:IMAGE:system";
     }
#endif

  /* if the default is specified and exists, use it
   *
   * this is used by applications that supply their own image
   */

  if (dflt && os_file_exists_p(dflt))
     return dflt;

  /* look in ~/lib/rs/$RSCHEME_VERSION/system.img  */

  if (os_getenv("HOME"))
    {
      strcpy( image_path, os_getenv( "HOME" ) );
      strcat( image_path, "/lib/rs/" RSCHEME_VERSION "/system.img" );
      if (os_file_exists_p(image_path))
	return image_path;
    }

  /* look in [install]/resource/system.img */

  strcpy(image_path, rs_install_dir);
  strcat(image_path, "/resource/system.img");
  if (os_file_exists_p(image_path))
    return image_path;

  // If argv[0] is of the form foo/bin/blech then look for
  // foo/resource/blech.img.
  base = strrchr(arg0, '/');
  if (base != NULL && try_image(arg0, base))
    return image_path;

  if (try_image(arg0, "system"))
    return image_path;

  strcpy(image_path, "../resource/system.img");
  if (os_file_exists_p(image_path))
    return image_path;

  return NULL;
}
