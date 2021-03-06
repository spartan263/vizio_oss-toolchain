# Customize maint.mk for Autoconf.            -*- Makefile -*-
# Copyright (C) 2003, 2004, 2006, 2008, 2009 Free Software Foundation,
# Inc.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This file is '-include'd into GNUmakefile.

# Build with our own versions of these tools, when possible.
export PATH = $(shell echo "`pwd`/tests:$$PATH")

# Remove the autoreconf-provided INSTALL, so that we regenerate it.
_autoreconf = autoreconf -i -v && rm -f INSTALL

# Version management.
announce_gen   = $(srcdir)/build-aux/announce-gen

# Use alpha.gnu.org for alpha and beta releases.
# Use ftp.gnu.org for major releases.
gnu_ftp_host-alpha = alpha.gnu.org
gnu_ftp_host-beta = alpha.gnu.org
gnu_ftp_host-major = ftp.gnu.org
gnu_rel_host = $(gnu_ftp_host-$(RELEASE_TYPE))

url_dir_list = \
  ftp://$(gnu_rel_host)/gnu/autoconf

# The GnuPG ID of the key used to sign the tarballs.
gpg_key_ID = F4850180

# The local directory containing the checked-out copy of gnulib used in this
# release.
gnulib_dir = '$(abs_srcdir)'/../gnulib

# Update files from gnulib.
.PHONY: fetch gnulib-update autom4te-update
fetch: gnulib-update autom4te-update

gnulib-update:
	cp $(gnulib_dir)/build-aux/announce-gen $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/config.guess $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/config.sub $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/elisp-comp $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/gendocs.sh $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/git-version-gen $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/gnupload $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/install-sh $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/mdate-sh $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/missing $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/move-if-change $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/vc-list-files $(srcdir)/build-aux
	cp $(gnulib_dir)/build-aux/texinfo.tex $(srcdir)/build-aux
	cp $(gnulib_dir)/doc/fdl.texi $(srcdir)/doc
	cp $(gnulib_dir)/doc/gendocs_template $(srcdir)/doc
	cp $(gnulib_dir)/doc/gnu-oids.texi $(srcdir)/doc
	cp $(gnulib_dir)/doc/make-stds.texi $(srcdir)/doc
	cp $(gnulib_dir)/doc/standards.texi $(srcdir)/doc
	cp $(gnulib_dir)/top/GNUmakefile $(srcdir)

WGET = wget
WGETFLAGS = -C off

## Fetch the latest versions of files we care about.
automake_gitweb = \
  http://git.savannah.gnu.org/gitweb/?p=automake.git;a=blob_plain;hb=HEAD;
autom4te_files = \
  Autom4te/Configure_ac.pm \
  Autom4te/Channels.pm \
  Autom4te/FileUtils.pm \
  Autom4te/Struct.pm \
  Autom4te/XFile.pm

move_if_change = '$(abs_srcdir)'/build-aux/move-if-change

autom4te-update:
	rm -fr Fetchdir > /dev/null 2>&1
	mkdir -p Fetchdir/Autom4te
	for file in $(autom4te_files); do \
	  infile=`echo $$file | sed 's/Autom4te/Automake/g'`; \
	  $(WGET) $(WGET_FLAGS) \
	    "$(automake_gitweb)f=lib/$$infile" \
	    -O "Fetchdir/$$file" || exit; \
	done
	perl -pi -e 's/Automake::/Autom4te::/g' Fetchdir/Autom4te/*.pm
	for file in $(autom4te_files); do \
	  $(move_if_change) Fetchdir/$$file $(srcdir)/lib/$$file || exit; \
	done
	rm -fr Fetchdir > /dev/null 2>&1
	@echo
	@echo "Please avoid committing copyright changes until GPLv3 is sorted"
	@echo

# Tests not to run.
local-checks-to-skip ?= \
  changelog-check sc_unmarked_diagnostics

.PHONY: web-manual
web-manual:
	@cd $(srcdir)/doc ; \
	  $(SHELL) ../build-aux/gendocs.sh -o '$(abs_builddir)/doc/manual' \
	    --email $(PACKAGE_BUGREPORT) $(PACKAGE) \
	    "$(PACKAGE_NAME) - Creating Automatic Configuration Scripts"
	@echo " *** Upload the doc/manual directory to web-cvs."
