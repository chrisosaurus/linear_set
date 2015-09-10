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

    return 0;
}

