# Linear set [![Build Status](https://travis-ci.org/mkfifo/linear_set.svg)](https://travis-ci.org/mkfifo/linear_set) [![Coverage Status](https://coveralls.io/repos/mkfifo/linear_set/badge.svg)](https://coveralls.io/r/mkfifo/linear_set)

A set implementation written in pure C (c99), uses linear probing for hash collisions

Currently linear set only supports string members

Linear set is licensed under the MIT license, see LICENSE for more details

Hashing function
----------------

linear_set uses an implementation of djb2,
below is the reference implementation which can also be
found on [http://www.cse.yorku.ca/~oz/hash.html](http://www.cse.yorku.ca/~oz/hash.html)

    unsigned long
    hash(unsigned char *str)
    {
        unsigned long hash = 5381;
        int c;

        while (c = *str++)
            hash = ((hash << 5) + hash) + c; /* hash * 33 + c */

        return hash;
    }

Example usage
--------------

    #include "linear_set.h"

    int main(void){
        /* create a set
         * the set will automatically manage
         * it's size
         */
        struct ls_set *s = ls_new();

        /* insert new strings */
        ls_insert(s, "hello");
        ls_insert(s, "world");

        /* delete existing string */
        ls_delete(s, "world");

        /* check a key exists */
        if( ls_exists(s, "hello") ){
        }

        /* tidy up
         * free table
         * destroy(table, free_table) */
        ls_destroy(s,     1);
    }

