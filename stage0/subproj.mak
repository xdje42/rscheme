##
## Subproject makefile fragment
##

SUBPROJECTS=corelib low-scheme objsys tables mathlib iolib regex sort imageio editinp

SUBPROJ_DIRS=corelib lowscm objsys tables mathlib iolib regex sort imageio editinp

SUBPROJ_DEPS=corelib/corelib.o \
	lowscm/low_scheme.o \
	objsys/objsys.o \
	tables/tables.o \
	mathlib/mathlib.o \
	iolib/iolib.o \
	regex/regex.o \
	sort/sort.o \
	imageio/imageio.o \
	editinp/editinp.o

corelib corelib/corelib.o::
	cd corelib && $(MAKE)

low-scheme lowscm/low_scheme.o::
	cd lowscm && $(MAKE)

objsys objsys/objsys.o::
	cd objsys && $(MAKE)

tables tables/tables.o::
	cd tables && $(MAKE)

mathlib mathlib/mathlib.o::
	cd mathlib && $(MAKE)

iolib iolib/iolib.o::
	cd iolib && $(MAKE)

regex regex/regex.o::
	cd regex && $(MAKE)

sort sort/sort.o::
	cd sort && $(MAKE)

imageio imageio/imageio.o::
	cd imageio && $(MAKE)

editinp editinp/editinp.o::
	cd editinp && $(MAKE)

