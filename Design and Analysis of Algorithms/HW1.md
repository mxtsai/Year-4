# HW1 - Design and Analysis of Algorithms

## Q1
Suppose you had an algorithm for finding a minimum vertex cover in a given graph in time T(n).
Explain how you could use this algorithm to find a maximum clique in a given graph (over n vertices)
in time O(T(n) + poly(n)). You do not need to give a full formal proof – an informal but clear
explanation suffices.

Hint: think of the complementary graph (that is, in which non-edges are replaced by edges and edges
by non-edges).

### Answer: 
Algorithm: 
1. Compute the complementary graph G* of the graph G=(V,E).
2. Run Minimum Vertex Cover on the new graph G*

