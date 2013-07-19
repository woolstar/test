
#### base85r

Ascii85 encoding/decoding using the RFC 1924 alphabet (safe for code strings).

Usage:

	base85r [-w N] [-d] [-i] [FILE]

Options:

	-w N	Set wrap to N characters, (0 for no wrap).  Default is 75.

	-d	Decode instead of encode.

	-i	Ingore any invalid characters in decode stream.

**FILE** is optional, will read from <tt>stdin</tt> if not supplied.

