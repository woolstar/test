
Ascii85 RFC 1924
----------------

Ascii85 provides an effecient packing of four bytes into five printable characters.
(More compact that uuencode or Base64)

The symbol set is <tt>0–9</tt>, <tt>A–Z</tt>, <tt>a–z</tt>, and then the 23 characters <tt>!#$%&()*+-;<=>?@^_`{|}~</tt>. 
This avoids certain problematic characters <tt>"',./:[]\\</tt> which allows for embedding data in code strings or JSON streams.

