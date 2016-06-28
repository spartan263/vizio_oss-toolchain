/* Copyright (C) 1995, 1996, 1997, 2003 Free Software Foundation, Inc.
   This file is part of the GNU C Library.

   The GNU C Library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   The GNU C Library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public
   License along with the GNU C Library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
   02111-1307 USA.  */

#ifndef _SYSCALL_H
#define _SYSCALL_H	1

/* This file should list the numbers of the system the system knows.
   But instead of duplicating this we use the information available
   from the kernel sources.  */
#ifdef _LIBC
/* Since the kernel doesn't define macro names in a way usable for
   glibc, we preprocess this header, and use it during the glibc build
   process.  */
# include <asm-unistd.h>
#else
# include <asm/unistd.h>
#endif

#ifndef _LIBC
/* The Linux kernel header file defines macros `__NR_<name>', but some
   programs expect the traditional form `SYS_<name>'.  So in building libc
   we scan the kernel's list and produce <bits/syscall.h> with macros for
   all the `SYS_' names.  */
# include <bits/syscall.h>
#endif

#endif