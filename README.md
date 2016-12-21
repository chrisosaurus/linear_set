# Linear set [![Build Status](https://travis-ci.org/mkfifo/linear_set.svg)](https://travis-ci.org/mkfifo/linear_set) [![Coverage Status](https://coveralls.io/repos/mkfifo/linear_set/badge.svg)](https://coveralls.io/r/mkfifo/linear_set) <a href="https://scan.coverity.com/projects/4861"> <img alt="Coverity Scan Build Status" src="https://scan.coverity.com/projects/4861/badge.svg"/> </a>

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

Internal implementation
-----------------------

Linear set is an unhardened linear probing hash backed by a dense array.

Every incoming key is first hashed, this hash is then taken and modulo-d to find
an appropriate slot for it, if this slot is already occupied then linear probing
is used to find the next available bucket.

The linear probe will search along the hash looking for an empty slot,
currently the probing step width is 1.

Linear set will automatically resize when the loading factor hits a threshold,
currently this threshold can be set by the user (via `ls_tune_threshold`) and
it defaults to 60% full.

This threshold value was pulled out of thin-air and I plan to investigate 
different threshold in the future.

Upon hitting this threshold linear set will double in size and rehash all
elements.

Linear set is not hardened and so is not recommended for use cases which would
expose it to attackers.

Each of the slots within the backing array is an instance of ls_entry which is
marked by an enum to show if it is in use or not,
it may be worth breaking this struct out into 2 or so arrays to improve cache
lines.

A rough diagram of the internals of how a linear set of size 8 would look:

      ls_table
    size    = 8
    n_elems = 4
    entries = *
              |
              v
              [ empty | occupied | occupied | occupied | empty | occupied | empty | empty ]
                        hash = X   hash = X   hash = Y           hash = Z
                        key  = *   key  = *   key  = *           key  = *

Here we can see an ls_table of size 8 containing 4 entries.

We can see that 2 of the entries collided on a hash of `X`,
the first to be inserted landed in the ideal bucket of [1]
the second to be inserted could not go here so linear probing begin
the linear probe starts stepping along the array and will insert the item into
the first empty slot is finds at [2].

If we assume that the hash `Y` also tried to use the same slot of [1]
then it too would have triggered a linear probe which would have stepped along
twice until it found the empty bucket at [3] which it was then inserted into.

From this table layout, if we assuming the X and Y collided, then we know
`X % 8 == Y % 8 == 1`
and
`Z % 8 == 5`.


