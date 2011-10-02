/*
 *  A table for the all symbols defined in tcc binary
 *
 *  Copyright (c) 2008 Shinichiro Hamaji
 *
 */

#ifndef NACL_SYMTAB
#ifdef __x86_64__
#define NACL_SYMTAB "x86_64-nacl-tccsyms.tab"
#else
#define NACL_SYMTAB "i686-nacl-tccsyms.tab"
#endif
#endif

typedef struct TCCSyms {
    char *str;
    void *ptr;
} TCCSyms;

#define TCCSYM(a) extern void *a;
#include NACL_SYMTAB

#undef TCCSYM
#define TCCSYM(a) { #a, &a, },
TCCSyms tcc_syms[] = {
#include NACL_SYMTAB
};

int tcc_nb_syms = sizeof(tcc_syms) / sizeof(TCCSyms);
