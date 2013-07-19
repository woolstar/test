
Ascii85 RFC 1924
----------------

Ascii85 provides an effecient packing of four bytes into five printable characters.
(More compact that uuencode or Base64)

The symbol set is <tt>0–9</tt>, <tt>A–Z</tt>, <tt>a–z</tt>, and then the 23 characters <tt>!#$%&()*+-;<=>?@^_`{|}~</tt>. 
This avoids certain problematic characters <tt>"',./:[]\\</tt> which allows for embedding data in code strings or JSON streams.

See this [wiki page](http://en.wikipedia.org/wiki/Ascii85) for the background.

Ways to use:

* asc85.c

A set of C routines for packing and unpacking longs, and higher level routines for unpacking/packing buffers.

* test.c

A test framework to verify operation.

* base85.c

A command line tool for encoding/decoding ascii85 (rfc) streams.  See [base85.md](base85.md) for usage.

