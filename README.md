# ruby-math

## Coxeter

* This one outputs details for a Coxeter group specified by the user.
* For example, the user may execute the program with argument "B 4" to get details about the Coxeter group $B_4$.
* The details included are the order, the Coxeter matrix, all its elements, its reflections, its involutions, its fixed-point-free involutions, and a Hasse diagram of the group elements under Bruhat order as a .dot file.
* This has only been completed for groups of type $A$, $B$, $D$, and $I$. 
* This program functions with a custom Coxeter group class and permutation library I've written.

## Dyck

* This program is called from the command line with a positive integer argument $n$, and it returns a list of Dyck words of length $2n$.

## Goldbach

* A positive integer $m$ has a Goldbach partition if there exist two prime integers $p$ and $q$ such that $p + q = m$.
* The Goldbach Conjecture asserts that every even integer $m = 2n$, with $n > 2$, has a Goldbach partition.
*This program is called from the command line with two positive integer arguments $m$ and $n$, and it returns all Goldbach parititions $(p_k, q_k)$ for every integer $2k$, with $m \leq k \leq n$.

## Poset

* I began to write a library to help deal with partially ordered sets, but this dropped off my radar a while back. However, I would love to get back into building a Rubdy poset library.