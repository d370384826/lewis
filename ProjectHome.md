In the spring of 2006, for a 4th quarter computer science project, this Lewis structure program was born.  Made with Ruby and the ImageMagick bindings, it is able to generate primitive lewis structures for covalent compounds with 2 distinct elements or less.  (For example, N2, O2, F2, CH4, SF4, etc.)  Due to lack of time or desire to continue and expand the program, it has been pretty much abandoned, although feel free to email should any questions arise about the source.

To run the program, you must have both Ruby and ImageMagick (and librmagick-ruby, I think).  Run with `ruby main.rb`, and type in the name of a compound.  The resulting lewis structure should be written to lewis.png in the same folder.