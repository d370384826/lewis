/*
#  API. The following set of functions should be written, which will be used as an interface for the programmer. Other functions may be added in order to make your code more readable and flexible.

   1. struct hash_table* create_hash_table(int size);

      Create an empty hash table, with "size" cells. Return a pointer to a structure with the table's information, of NULL in case of failure (e.g. out of free memory).

   2. int hash_insert(struct hash_table* htable, char* key, void* element);

      Insert the given element, with the given key, to the given hash table. Return '1' on success, '0' if an element with the same key is already found in the table, or '-1' if the table is full.

   3. void* hash_remove(struct hash_table* htable, char* key);

      Remove the element with the given key from the hash table. Return a pointer to the removed element, or NULL if the element was not found in the table.

   4. int hash_num_elements(struct hash_table* htable);

      Return the number of elements found in the given hash table.

   5. void destroy_hash_table(struct hash_table* htable);

      Delete the given hash table, freeing any memory it currently uses (but do NOT free any elements that might still be in it).

   6. int hash_value(struct hash_table* htable, char* key);

      Not an external function, but a must. There was a lot of research done regarding "what is a good hashing function?". I'll present a very simple one here, but you should try your own ideas, and test them out on various input sets:

                Add the ASCII values of all characters in the key, and take the
                result of their sum modulo the table size (in C notation, the '%'
                operator calculates the modulo of a number. "i1 Modulo i2" means
                "the remainder of dividing i1 by i2).
                



# Table With Varying Size. Since we saw how important it is for the table not to be too dense, we will now implement a hash table of varying size. When an element's insertion causes the table to be too dense (for example, more than 70% filled), we will make the table twice as large (thus making it about 35% filled). When an element's deletion causes the table to be too dense (for example, less than 20% filled), we will cut its size by half (making it about 40% filled).
These table expansion and shrinking operations might be very costly - we need to modify the hash function so that it will generate numbers within the new range, and need to re-insert all the elements into the new table. However, in most operations we win the efficiency of the very sparse table, so the efficiency for a set of insertion, deletion and lookup operations is still kept. An Extended API is required to support this modified table:

   1. void hash_set_resize_high_density(struct hash_table* htable, int fill_factor);

      Set the fill density of the table after which it will be expanded. The fill factor is a number between 1 and 100.

   2. void hash_set_resize_low_density(struct hash_table* htable, int fill_factor);

      Set the fill density of the table below which it will be shrank. The fill factor is a number between 1 and 100.

   3. int hash_get_resize_high_density(struct hash_table* htable);

      Get the "high" fill density of the table. The fill factor is a number between 1 and 100.

   4. void hash_get_resize_low_density(struct hash_table* htable);

      Get the "low" fill density of the table. The fill factor is a number between 1 and 100.
*/

struct hash_table {
	char* key;
	int value;
}

struct hash_table* create_hash_table(int size) {
	
int hash_insert(struct hash_table* htable, char* key, void* element);
void* hash_remove(struct hash_table* htable, char* key);
int hash_num_elements(struct hash_table* htable);
void destroy_hash_table(struct hash_table* htable);
int hash_value(struct hash_table* htable, char* key);

void hash_set_resize_high_density(struct hash_table* htable, int fill_factor);
void hash_set_resize_low_density(struct hash_table* htable, int fill_factor);
int hash_get_resize_high_density(struct hash_table* htable);
void hash_get_resize_low_density(struct hash_table* htable);