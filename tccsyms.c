/*
 *  A table for the all symbols defined in tcc binary
 *
 *  Copyright (c) 2008 Shinichiro Hamaji
 *
 */
typedef struct TCCSyms {
    char *str;
    void *ptr;
} TCCSyms;

#define TCCSYM(a) extern void *a;
#include "tccsyms.tab"

#undef TCCSYM
#define TCCSYM(a) { #a, &a, },
TCCSyms tcc_syms[] = {
#include "tccsyms.tab"
};

int tcc_nb_syms = sizeof(tcc_syms) / sizeof(TCCSyms);
