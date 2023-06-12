#lang dssl2

let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]
# HW4: Graph
#
# ** You must work on your own for this assignment. **

import cons

###
### REPRESENTATION
###

# A Vertex is a natural number.
let Vertex? = nat?

# A VertexList is either
#  - None, or
#  - cons(v, vs), where v is a Vertex and vs is a VertexList
let VertexList? = Cons.ListC[Vertex?]

# A Weight is a real number. (It’s a number, but it’s neither infinite
# nor not-a-number.)
let Weight? = AndC(num?, NotC(OrC(inf, -inf, nan)))

# An OptWeight is either
# - a Weight, or
# - None
let OptWeight? = OrC(Weight?, NoneC)

# A WEdge is WEdge(Vertex, Vertex, Weight)
struct WEdge:
    let u: Vertex?
    let v: Vertex?
    let w: Weight?

# A WEdgeList is either
#  - None, or
#  - cons(w, ws), where w is a WEdge and ws is a WEdgeList
let WEdgeList? = Cons.ListC[WEdge?]

# A weighted, undirected graph ADT.
interface WU_GRAPH:

    # Returns the number of vertices in the graph. (The vertices
    # are numbered 0, 1, ..., k - 1.)
    def len(self) -> nat?

    # Sets the weight of the edge between u and v to be w. Passing a
    # real number for w updates or adds the edge to have that weight,
    # whereas providing providing None for w removes the edge if
    # present. (In other words, this operation is idempotent.)
    def set_edge(self, u: Vertex?, v: Vertex?, w: OptWeight?) -> NoneC
             

    # Gets the weight of the edge between u and v, or None if there
    # is no such edge.
    def get_edge(self, u: Vertex?, v: Vertex?) -> OptWeight?

    # Gets a list of all vertices adjacent to v. (The order of the
    # list is unspecified.)
    def get_adjacent(self, v: Vertex?) -> VertexList?

    # Gets a list of all edges in the graph, in an unspecified order.
    # This list only includes one direction for each edge. For
    # example, if there is an edge of weight 10 between vertices
    # 1 and 3, then exactly one of WEdge(1, 3, 10) or WEdge(3, 1, 10)
    # will be in the result list, but not both.
    def get_all_edges(self) -> WEdgeList?

class WuGraph (WU_GRAPH):
    let _size
    let matrix
### ^ YOUR FIELDS HERE

    def __init__(self, size: nat?):
        self._size = size
        self.matrix = [[None;size] for i in range(size)]
### ^ YOUR CODE HERE

    def len(self):
        return self._size
### ^ YOUR CODE HERE

    def set_edge(self, u, v, weight):
        if u != v:
            
            if self.matrix[u][v] and self.matrix[v][u] == None:
            
                self.matrix[u][v] = weight
            
            elif self.matrix[u][v] == None:
                self.matrix[v][u] = weight
             
            elif self.matrix[v][u] == None:
                self.matrix[u][v] = weight
            
        else:
            self.matrix[u][v] = weight
            self.matrix[v][u] = weight
            
            
           
                #self.matrix[u][v] = weight
                #self.matrix[v][u] = self.matrix
### ^ YOUR CODE HERE

    def get_edge(self, u, v):
        if self.matrix[u][v] != None:
            return self.matrix[u][v] 
        elif self.matrix[v][u] != None:
            return self.matrix[v][u] 
            
        else:
            return None
### ^ YOUR CODE HERE

    def get_adjacent(self, v):
        let curr = None
        for u in range(self._size):
            if u != v:
                if self.matrix[v][u] != None:
                   curr = cons(u,curr)
        for u in range(self._size):
            if u != v:
                if self.matrix[u][v] != None:
                   curr = cons(u,curr)       
        return curr
                
            
### ^ YOUR CODE HERE

    def get_all_edges(self):
        let curr = None
        for u in range(len(self.matrix)):
            for v in range(len(self.matrix[u])):
                 if self.matrix[v][u] != None:
                    
                     curr = cons(WEdge(u,v,self.matrix[v][u]),curr)
        return curr   
### ^ YOUR CODE HERE

###
### BUILDING GRAPHS
###

def example_graph() -> WuGraph?:
    let result = WuGraph(6) # 6-vertex graph from the assignment
    result.set_edge(0, 1,12)
    result.set_edge(1, 2,31)
    result.set_edge(1, 3,56)
    result.set_edge(2, 4,-2)
    result.set_edge(2, 5,7)
    result.set_edge(3, 4,9)
    result.set_edge(3, 5,1)
    
    return result 
### ^ YOUR CODE HERE

struct CityMap:
    let graph: WuGraph?
    let dict: VecC[str?]

def my_neck_of_the_woods():
    let city_names = ["Montreal","Laval","Repentigny","Terrebonne","Potton", "Saint-Charles-sur-Richelieu"]
    let result = WuGraph(6)
    result.set_edge(0, 1,12)
    result.set_edge(1, 2,31)
    result.set_edge(1, 3,56)
    result.set_edge(2, 4,-2)
    result.set_edge(2, 5,7)
    result.set_edge(3, 4,9)
    result.set_edge(3, 5,1)
    
    let map = CityMap(result,city_names)
    return map
    ### ^ YOUR CODE HERE

###
### List helpers
###

# For testing functions that return lists, we provide a function for
# constructing a list from a vector, and functions for sorting (since
# the orders of returned lists are not determined).

# list : VecOf[X] -> ListOf[X]
# Makes a linked list from a vector.
def list(v: vec?) -> Cons.list?:
    return Cons.from_vec(v)

# sort_vertices : ListOf[Vertex] -> ListOf[Vertex]
# Sorts a list of numbers.
def sort_vertices(lst: Cons.list?) -> Cons.list?:
    def vertex_lt?(u, v): return u < v
    return Cons.sort[Vertex?](vertex_lt?, lst)

# sort_edges : ListOf[WEdge] -> ListOf[WEdge]
# Sorts a list of weighted edges, lexicographically
# ASSUMPTION: There's no need to compare weights because
# the same edge can’t appear with different weights.
def sort_edges(lst: Cons.list?) -> Cons.list?:
    def edge_lt?(e1, e2):
        return e1.u < e2.u or (e1.u == e2.u and e1.v < e2.v)
    return Cons.sort[WEdge?](edge_lt?, lst)

###
### DFS
###

# dfs : WU_GRAPH Vertex [Vertex -> any] -> None
# Performs a depth-first search starting at `start`, applying `f`
# to each vertex once as it is discovered by the search.
def dfs(graph: WU_GRAPH!, start: Vertex?, f: FunC[Vertex?, AnyC]) -> NoneC:
    if start < 0:
        error ("the start must be a non-negative value")
    else:
        let seen = [False;graph.len()]
    
        def Traverse(v):
           if not seen[v]:
                seen[v]=True
                f(v)
                let curr = graph.get_adjacent(v)
                while curr is not None:
                    Traverse(curr.car)
                    curr= curr.cdr
        Traverse(start)
        return 
### ^ YOUR CODE HERE

# dfs_to_list : WU_GRAPH Vertex -> ListOf[Vertex]
# Performs a depth-first search starting at `start` and returns a
# list of all reachable vertices.
#
# This function uses your `dfs` function to build a list in the
# order of the search. It will pass the test below if your dfs visits
# each reachable vertex once, regardless of the order in which it calls
# `f` on them. However, you should test it more thoroughly than that
# to make sure it is calling `f` (and thus exploring the graph) in
# a correct order.
def dfs_to_list(graph: WU_GRAPH!, start: Vertex?) -> VertexList?:
    let builder = Cons.Builder()
    dfs(graph, start, builder.snoc)
    return builder.take()

###
### TESTING
###

## You should test your code thoroughly. Here is one test to get you started:

test 'dfs_to_list(example_graph())':
    assert sort_vertices(dfs_to_list(example_graph(), 0)) \
        == list([0, 1, 2, 3, 4, 5])
    assert sort_vertices(dfs_to_list(example_graph(), 1)) \
        == list([0, 1, 2, 3, 4, 5])
    assert sort_vertices(dfs_to_list(example_graph(), 2)) \
        == list([0, 1, 2, 3, 4, 5])
    assert sort_vertices(dfs_to_list(example_graph(), 3)) \
        == list([0, 1, 2, 3, 4, 5])
    assert sort_vertices(dfs_to_list(example_graph(), 4)) \
        == list([0, 1, 2, 3, 4, 5])
    assert sort_vertices(dfs_to_list(example_graph(), 5)) \
        == list([0, 1, 2, 3, 4, 5])

test "WuGraph functions":
    let a = WuGraph(8)
    assert a.len() ==  8
    sort_edges(a.get_all_edges())== None
    a.set_edge(0, 1,12)
    a.set_edge(1, 2,31)
    a.set_edge(1, 3,56)
    a.set_edge(2, 4,-2)
    a.set_edge(2, 5,7)
    a.set_edge(3, 4,9)
    a.set_edge(3, 5,1)
    a.set_edge(1, 1,1)
    assert a.len() ==  8
    
    assert a.get_edge(2,5)==7
    assert a.get_edge(2,6)== None
    assert a.get_edge(7,6)== None
    assert a.get_edge(1,1)== 1
    assert a.get_edge(5,3)==1
    assert a.get_edge(2,5)== a.get_edge(5,2)
    assert a.get_adjacent(6)==None
    assert sort_vertices(a.get_adjacent(1)) == sort_vertices(list([0,2,3]))
     
    sort_edges(a.get_all_edges()) == sort_edges(list([WEdge(0,1,12),WEdge(1,2,31),WEdge(1,3,56),WEdge(2,4,-2),WEdge(2,5,7),WEdge(3,4,9),WEdge(3,5,1)]))

    
test "Edge is None" :
    let a = WuGraph(6)
    assert a.len() ==  6
    a.set_edge(1, 3,13)
    a.set_edge(2, 4,8)
    a.set_edge(2, 5,7)
    a.set_edge(3, 4,9)
    a.set_edge(4, 5,20) 
    assert a.get_edge(2, 4)==8
    assert sort_vertices(a.get_adjacent(2)) == sort_vertices(list([4,5]))
    a.set_edge(2, 4,None)
    assert a.get_edge(2, 4)== None
    assert sort_vertices(a.get_adjacent(2)) == sort_vertices(list([5]))
    
    sort_edges(a.get_all_edges()) == sort_edges(list([WEdge(1,3,13),WEdge(2,4,8),WEdge(2,5,7),WEdge(3,4,9),WEdge(4,5,20)]))

    a.set_edge(1, 3,None)
    sort_edges(a.get_all_edges()) == sort_edges(list([WEdge(2,4,8),WEdge(2,5,7),WEdge(3,4,9),WEdge(4,5,20)]))

test "change value for edges":
    let a = WuGraph(5)
    assert a.len() ==  5
    a.set_edge(1, 3,13)
    a.set_edge(2, 4,8)
    a.set_edge(2, 3,7)
    a.set_edge(3, 4,9)
    a.set_edge(3, 4,14)
    assert a.get_edge(3, 4) == 14
    a.set_edge(3, 4,0)
    assert a.get_edge(3, 4) == 0
 
test "Example Graph" :  
    assert  example_graph().len() == 6
    assert example_graph().get_edge(2,5)==7
    assert example_graph().get_edge(2,5)== example_graph().get_edge(5,2)
    assert sort_vertices(example_graph().get_adjacent(1)) == sort_vertices(list([0,2,3]))
    sort_edges(example_graph().get_all_edges()) == sort_edges(list([WEdge(0,1,12),WEdge(1,2,31),WEdge(1,3,56),WEdge(2,4,-2),WEdge(2,5,7),WEdge(3,4,9),WEdge(3,5,1)]))

test   "No edges graph":
    let b = WuGraph(8)
    assert b.len() ==  8
    b.set_edge(0, 1,12)
    sort_edges(b.get_all_edges()) == sort_edges(list([WEdge(0,1,12)]))
    b.set_edge(0, 1,12)
test "Neck of the woods":
    assert my_neck_of_the_woods().graph.get_edge(2, 5)==7
    assert my_neck_of_the_woods().graph.get_edge(1, 5)== None
    sort_edges(my_neck_of_the_woods().graph.get_all_edges()) == sort_edges(list([WEdge(0,1,12),WEdge(1,2,31),WEdge(1,3,56),WEdge(2,4,-2),WEdge(2,5,7),WEdge(3,4,9),WEdge(3,5,1)]))
    assert my_neck_of_the_woods().graph.len()==6
    assert sort_vertices(my_neck_of_the_woods().graph.get_adjacent(1)) == sort_vertices(list([0,2,3]))
    
test "dfs":
    let a = WuGraph(15)
    assert a.len() ==  15
    a.set_edge(0, 1,12)
    a.set_edge(1, 2,31)
    a.set_edge(1, 3,56)
    a.set_edge(2, 4,-2)
    a.set_edge(2, 5,7)
    a.set_edge(3, 4,9)
    a.set_edge(3, 5,1)
    a.set_edge(1, 1,1)
    
    assert sort_vertices(dfs_to_list(a, 0)) \
        == list([0, 1, 2, 3, 4, 5])
    assert sort_vertices(dfs_to_list(a, 7)) \
        == list([7])
    #calling dfs on different clusters of the graph which are not linked to each other
    a.set_edge(7, 8,19)
    a.set_edge(7, 9,17)
    assert sort_vertices(dfs_to_list(a, 7)) \
        == list([7,8,9])
    assert sort_vertices(dfs_to_list(a, 1)) \
        == list([0, 1, 2, 3, 4, 5])
        
    a.set_edge(10,10,16)
    assert sort_vertices(dfs_to_list(a, 10)) \
        == list([10])