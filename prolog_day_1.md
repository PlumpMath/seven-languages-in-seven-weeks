# Find

1. Some free Prolog tutorials.

  - https://www.csupomona.edu/~jrfisher/www/prolog_tutorial/contents.html
  - http://classes.soe.ucsc.edu/cmps112/Spring03/languages/prolog/PrologIntro.pdf
  - http://www.doc.gold.ac.uk/~mas02gw/prolog_tutorial/prologpages/
  - http://www.learnprolognow.org/

2. A support forum (there are several).

  - https://groups.google.com/group/comp.lang.prolog
  - http://www.reddit.com/r/prolog/
  - http://stackoverflow.com/questions/tagged/prolog

3. One online reference for the Prolog version you're using.

  http://www.swi-prolog.org/

# Do

1. Make a simple knowledge base. Represent some of you favorite books and
   authors.

   ```Prolog
   book_author('The Brothers Karamazov', 'Fyodor Dostoyevsky').
   book_author('The Idiot', 'Fyodor Dostoyevsky').
   book_author('The Pragmatic Programmer', 'Andrew Hunt, Dave Thomas').
   book_author('The Pillars of The Earth', 'Ken Follet').
   book_author('Eye of the Needle', 'Ken Follet').
   book_author('Harry Potter and the Methods of Rationality', 'Eliezer Yudkowsky').
   ```

2. Find all books in your knowledge base written by one author.

   ```Prolog
   ?- book_author(Title, 'Fyodor Dostoyevsky').
   Title = 'The Brothers Karamazov';
   Title = 'The Idiot'.
   ```

3. Make a knowledge base representing musicians and instruments. Also represent
   musicians and their genre of music.

   ```Prolog
   musician_instrument('Roger Waters', 'Bass').
   musician_instrument('David Gilmour', 'Guitar').
   musician_instrument('Rick Wright', 'Keyboard').
   musician_instrument('Nick Mason', 'Drums').
   musician_genre('Roger Waters', 'Progressive Rock').
   musician_genre('David Gilmour', 'Progressive Rock').
   musician_genre('Rick Wright', 'Progressive Rock').
   musician_genre('Nick Mason', 'Progressive Rock').
   musician_instrument('Ozzy Osbourne', 'Vocals').
   musician_instrument('Toni Iommi', 'Guitar').
   musician_instrument('Geezer Butler', 'Bass').
   musician_instrument('Bill Ward', 'Drums').
   musician_genre('Ozzy Osbourne', 'Heavy Metal').
   musician_genre('Toni Iommi', 'Heavy Metal').
   musician_genre('Geezer Butler', 'Heavy Metal').
   musician_genre('Bill Ward', 'Heavy Metal').
   ```

4. Find all musicians who play the guitar.

   ```Prolog
   ?- musician_instrument(Who, 'Guitar').
   Who = 'David Gilmour';
   Who = 'Toni Iommi'.
   ```
