maze solver
-----------

This is a simple maze solver.

The input is basically made of a list of strings.

'#' is representing a block
'.' is representing a free tile

You can only walk on the free tile (not on a block)

There is two versions of the solver, one in Python, the other in Haskell.

Interestingly, the number of LOCs is pretty much equivalent (~90 lines for 
Haskell, 80 for the Python maze solver).

The Haskell version uses a set to keep track of the visited nodes, the 
python version uses in-place flags ('t' for visited, 'f' for not visited).

Haskell is faster than Python but precise timing would be required in order
to assert the real differences.
