#lang dssl2
let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]

# HW6: Union-Find
#
# ** You must work on your own for this assignment. **

# This code depends on graph and binary heap implementations.
# We have provided you with compiled versions of homework 4 and 5 solutions,
# which are imported below.
# Be sure to extract the `hw6-lib` archive is the same directory as this file.

import 'hw6-lib/graph.rkt'
import 'hw6-lib/binheap.rkt'
import cons

##############################
##### PART I: UNION-FIND #####
##############################

class UnionFind:
    let size 
    let weight
    let id
    #### YOUR FIELDS GO HERE ####

    # Creates a new union-find structure having `len` initially-disjoint
    # sets numbered 0 through `len - 1`.
    def __init__(self, len: nat?):
        self.size = len
        self.weight = [1;self.size]
        self.id = [i for i in range(len)]

    # Returns the number of objects in the union-find.
    def len(self) -> nat?:
        return self.size

    # Returns the representative object for any given object.
    def find(self, o: nat?) -> nat?:
        if o == self.id[o]:
            return o
        else:
            self.id[o] = self.find(self.id[o])
            return self.id[o]

    # Unions the sets containing the two given objects.
    def union(self, o1: nat?, o2: nat?) -> NoneC:
        let x = self.find(o1)
        let y = self.find(o2)
        if o1 == o2:
            return
        if x == y:
            return
        else:
            if self.weight[x]<self.weight[y]:
                self.id[x] = y
                self.weight[y] = self.weight[y]+ self.weight[x]
                
            else:
                self.id[y] = x
                self.weight[x] = self.weight[x]+ self.weight[y]
       
                
    # Returns whether two objects are in the same set.
    def same_set?(self, o1: nat?, o2: nat?) -> bool?:
        return self.find(o1) == self.find(o2)


        
###
### UNION-FIND TESTING
###

test 'some unions':
    let u = UnionFind(10)
    assert not u.same_set?(0, 1)
    u.union(0, 1)
    assert u.same_set?(0, 1)
    u.union(1, 2)
    u.union(2, 3)
    assert u.same_set?(0, 3)
    assert not u.same_set?(0, 4)
    

test 'len':
   let u = UnionFind(10)
   assert u.len() == 10
   u.union(0, 1)
   u.union(1, 2)
   u.union(2, 3)
  
   assert u.len() == 10
   
   
test "find ":
   let u = UnionFind(10)
   u.union(3,4)
   assert u.find(3) == 3
   u.union(2,4)
   u.union(3,9)
   assert u.find(2) == 3
   u.union(6,5)
   assert u.same_set?(6,5) == True
   assert u.same_set?(3,5) == False
   u.union(2,5)
   assert u.find(5) == 3
   
   assert u.find(7) == 7
   
   
test "union":
   let u = UnionFind(10)
   u.union(1,1)
   assert u.find(1) == 1
   u.union(2,1)# to determine that the weight of 1 does not change 
   assert u.find(1) == 2
   u.union(1,3)
   u.union(5,3)
   assert u.find(5) == 2
   u.union(5,1)# already have the same parent
   assert u.find(5) == 2
   
test "out of range ":
   let u = UnionFind(10)
   assert_error u.union(3,20)
   assert_error u.find(20)
   assert_error u.same_set?(0, 20)
   
   
test "tree of diferent sizes":
   let u = UnionFind(10)
   u.union(1,3)
   u.union(2,3)
   u.union(1,4)
   u.union(5,2)
   
   assert u.find(5) == 1
   
   u.union(7,6)
   u.union(6,8)
   u.union(9,8)
   
   assert u.find(9) == 7
   
   u.union(7,5)
   u.same_set?(7, 5)
 
   assert u.find(7) == 1
   assert u.find(5) == 1
   
   
   
## You need more tests!

#############################################
###### PART II: KRUSKAL’S MST ALGORITHM #####
#############################################

# Returns the minimum spanning forest for a given graph, represented as
# a new graph.
def kruskal_mst(g: WuGraph?) -> WuGraph?:
    let uf = UnionFind(g.len())
    let forest = WuGraph(g.len())

    for edge in  _get_all_edges_increasing(g):
        if not uf.same_set?(edge.u,edge.v):
            uf.union(edge.u,edge.v)
            forest.set_edge(edge.u,edge.v,edge.w)
    return forest
###
### KRUSKAL HELPER YOU MAY FIND USEFUL
###

# _get_all_edges_increasing : WUGraph -> VecC[WEdge]
# Gets a vector of all the edges in the graph sorted by increasing weight;
# includes only one (arbitrary) direction for each edge.
def _get_all_edges_increasing(g: WuGraph?) -> VecC[WEdge?]:
    let edges = Cons.to_vec(g.get_all_edges())
    heap_sort(edges, λ x, y: x.w < y.w)
    edges

###
### MST TESTING
###

# Graph equality is useful for MST testing.
def _same_graph?(g1, g2):
    if g1.len() != g2.len(): return False
    for u in range(g1.len()):
        for v in range(u, g1.len()):
            if g1.get_edge(u, v) != g2.get_edge(u, v):
                return False
    return True

# Here is an example graph:

def _GRAPH0():
    let g = WuGraph(6)
    let a = g.set_edge
    a(0, 1, 5)
    a(0, 2, 7)
    a(0, 3, 2)
    a(1, 4, 9)
    a(1, 5, 6)
    a(3, 5, 0)
    a(3, 4, 1)
    return g

def _GRAPH0_MST():
    let g = WuGraph(6)
    let a = g.set_edge
    a(0, 1, 5)
    a(0, 2, 7)
    a(0, 3, 2)
    a(3, 5, 0)
    a(3, 4, 1)
    return g

test 'graph0 mst':
    assert _same_graph?(kruskal_mst(_GRAPH0()), _GRAPH0_MST())

### You need more tests than this.
## FURTHER TESTS
def _GRAPH1():
    let g = WuGraph(7)
    let a = g.set_edge
    a(0, 1, 28)
    a(0, 5, 10)
    a(5, 4, 25)
    a(4, 6, 24)
    a(6, 1, 14)
    a(4, 3, 22)
    a(3, 6, 18)
    a(3, 2, 12)
    a(2, 1, 16)
    return g
    
    
def _GRAPH1_MST():
    let g = WuGraph(7)
    let a = g.set_edge
    a(0, 5, 10)
    a(5, 4, 25)
    a(4, 3, 22)
    a(3, 2, 12)
    a(2, 1, 16)
    a(1, 6, 14)
    return g
    
test 'graph1 mst':
    assert _same_graph?(kruskal_mst(_GRAPH1()), _GRAPH1_MST())
    
    
## Testing disconected graphs.

def _GRAPH2():
    let g = WuGraph(11)
    let a = g.set_edge
    a(0, 1, 28)
    a(0, 5, 10)
    a(5, 4, 25)
    a(4, 6, 24)
    a(6, 1, 14)
    a(4, 3, 22)
    a(3, 6, 18)
    a(3, 2, 12)
    a(2, 1, 16)
    # the disconeected vertices
    a(7, 8,4)
    a(8, 9, 5)
    a(9, 10,2)
    a(7, 10,1)
    a(7, 9,3)
    return g
    
    
def _GRAPH2_MST():
    let g = WuGraph(11)
    let a = g.set_edge
    a(0, 5, 10)
    a(5, 4, 25)
    a(4, 3, 22)
    a(3, 2, 12)
    a(2, 1, 16)
    a(1, 6, 14)
    # the disconeected vertices
    a(7, 10, 1)
    a(7, 8, 4)
    a(9, 10,2)
    
    return g
    
    
test 'graph2 mst':
    assert _same_graph?(kruskal_mst(_GRAPH2()), _GRAPH2_MST())
    
## Testing on an empty graph
    
def _GRAPH3():
    let g = WuGraph(5)
    return g
    
def _GRAPH3_MST():
    let g = WuGraph(5)
    return g
test 'graph mst':
    assert _same_graph?(kruskal_mst(_GRAPH3()), _GRAPH3_MST())
    
    
    
    
## Testing equal weight in the edges
    
def _GRAPH4():
    let g = WuGraph(4)
    let a = g.set_edge
    a(0, 1, 1)
    a(0, 3, 1)
    a(1, 2, 1)
    a(2, 3, 1)
    
    
    return g
    
def _GRAPH4_MST():
    let g = WuGraph(4)
    let a = g.set_edge
    a(0, 1, 1)
   
    a(1, 2, 1)
    a(2, 3, 1)
    
    return g
    
test 'graph mst':
    assert _same_graph?(kruskal_mst(_GRAPH4()), _GRAPH4_MST())    