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
 * Purpose:          Trivial "shell" application
 *------------------------------------------------------------------------*/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <rscheme/api.h>
#include <rscheme/osglue.h>
#include <rscheme/stdmodul.h>
#include <rscheme/rlseconf.h>

#ifdef PLATFORM_MAC_CODEWARRIOR
#include <stdio.h>
#include <sioux.h>
#endif

static struct module_descr *(std_modules[]) = { STD_MODULES_DECL };

// Return the value to use for rs_install_dir.
// Space for the result may or may not be malloc'd, this is ok because the
// value persists for the duration of the program.

static const char* find_rs_install_dir(const char* argv0)
{
  const char *install_dir = getenv("RS_INSTALL_DIR");
  if (install_dir)
    return install_dir;

  // Default to INSTALL_DIR, but see if we can self-relocate based on
  // where we're installed. We assume binaries are installed as
  // [install]/bin/<program>.

  // First make sure argv0 is an absolute path.
  // Space for canonical_argv0 is malloc'd by os_binary_path.
  char *canonical_argv0 = os_binary_path(argv0);
  if (canonical_argv0 == NULL)
    return INSTALL_DIR;

  char *potential_install_dir = canonical_argv0;
  char* slash1 = strrchr(potential_install_dir, '/');
  if (slash1)
  {
    *slash1 = '\0';
    char *slash2 = strrchr(potential_install_dir, '/');
    if (slash2)
    {
      *slash2 = '\0';

      // We have a potential installation, but don't use it unless we can
      // verify its validity.
      char *test_file_path;
      static const char test_file[] = "resource/system.img";

      test_file_path = malloc(
        strlen(potential_install_dir) + strlen(test_file) + 2);
      sprintf(test_file_path, "%s/%s", potential_install_dir, test_file);
      rs_bool exists_p = os_file_exists_p(test_file_path);
      free(test_file_path);
      if (exists_p)
      {
	// Don't print to stdout, that will collide with "rs --install" output.
	// TODO: Predicate on a verbosity flag.
	//fprintf(stderr, "Using install dir: %s\n", potential_install_dir);
        return potential_install_dir;
      }
    }
  }
  free(canonical_argv0);

  return INSTALL_DIR;
}

int main( int argc, const char **argv )
{
#ifdef PLATFORM_MAC_CODEWARRIOR
  /* configure the I/O window */
  SIOUXSettings.autocloseonquit = TRUE;
  SIOUXSettings.asktosaveonclose = TRUE;
#endif

  rs_install_dir = find_rs_install_dir(argv[0]);

#ifdef PLATFORM_MAC
  return rscheme_std_main( argc, argv, std_modules, "install/system.img" );
#else
  {
    char temp[1024];

    sprintf( temp, "%s/resource/system.img", rs_install_dir );
    return rscheme_std_main( argc, argv, std_modules, temp );
  }
#endif
}
