#ifndef _include_tls_h
#define _include_tls_h 1

#if USE_TLS && HAVE___THREAD \
    && (!defined NOT_IN_libc || defined IS_IN_libpthread)
# define USE___THREAD 1
#else
# define USE___THREAD 0
#endif

#endif
