#lang dssl2
#lang dssl2

# HW7: Trip Planner
#
# ** You must work on your own for this assignment. **

# Your program will most likely need a number of data structures, many of
# which you've implemented in previous homeworks.
# We have provided you with compiled versions of homework 3, 4, 5, and 6
# solutions. You can import them as you did in homework 6.
# Be sure to extract the `hw7-lib` archive is the same directory as this file.
# You may also import libraries from the DSSL2 standard library (e.g., cons,
# array, etc.).
import array
import cons
import sbox_hash
import 'hw7-lib/graph.rkt'
import 'hw7-lib/binheap.rkt'
import 'hw7-lib/dictionaries.rkt'
import 'hw7-lib/stack-queue.rkt'
import 'hw7-lib/unionfind.rkt'


### Basic Vocabulary Types ###

#  - Latitudes and longitudes are numbers:
let Lat?  = num?
let Lon?  = num?
#  - Point-of-interest categories and names are strings:
let Cat?  = str?
let Name? = str?

# ListC[T] is a list of `T`s (linear time):
let ListC = Cons.ListC

# List of unspecified element type (constant time):
let List? = Cons.list?


### Input Types ###

#  - a SegmentVector  is VecC[SegmentRecord]
#  - a PointVector    is VecC[PointRecord]
# where
#  - a SegmentRecord  is [Lat?, Lon?, Lat?, Lon?]
#  - a PointRecord    is [Lat?, Lon?, Cat?, Name?]


### Output Types ###

#  - a NearbyList     is ListC[PointRecord]; i.e., one of:
#                       - None
#                       - cons(PointRecord, NearbyList)
#  - a PositionList   is ListC[Position]; i.e., one of:
#                       - None
#                       - cons(Position, PositionList)
# where
#  - a PointRecord    is [Lat?, Lon?, Cat?, Name?]  (as above)
#  - a Position       is [Lat?, Lon?]


# Interface for trip routing and searching:
interface TRIP_PLANNER:
    # Finds the shortest route, if any, from the given source position
    # (latitude and longitude) to the point-of-interest with the given
    # name. (Returns the empty list (`None`) if no path can be found.)
    def find_route(
            self,
            src_lat:  Lat?,     # starting latitude
            src_lon:  Lon?,     # starting longitude
            dst_name: Name?     # name of goal
        )   ->        List?     # path to goal (PositionList)

    # Finds no more than `n` points-of-interest of the given category
    # nearest to the source position. (Ties for nearest are broken
    # arbitrarily.)
    def find_nearby(
            self,
            src_lat:  Lat?,     # starting latitude
            src_lon:  Lon?,     # starting longitude
            dst_cat:  Cat?,     # point-of-interest category
            n:        nat?      # maximum number of results
        )   ->        List?     # list of nearby POIs (NearbyList)

   
#struct position:
    #let coordinate
    #let points_of_interest
struct Dijkstra:
    let predicessors
    let dististances   
    
class TripPlanner (TRIP_PLANNER):
    let positions_to_node_ids 
    let node_ids_to_positions
    let name_to_positions
    let graph
    let rvector
    let poivector
    
    def __init__(self,roads,POI):
        self.rvector = roads
        self.poivector = POI
        let n_positions = self.graph.len()
        self.positions_to_node_ids = HashTable(n_positions, SboxHash64().hash)
        self.node_ids_to_positions = HashTable(n_positions, SboxHash64().hash)
        let node_number = 0
      
        for i in self.rvector:
            if [i[0],i[1]] not in self.positions_to_node_ids:
                self.positions_to_node_ids.put([i[0],i[1]],node_number)
                
            
                self.node_ids_to_positions.put(node_number,[i[0],i[1]])
               
                node_number = node_number + 1
            
            if [i[2],i[3]] not in self.positions_to_node_ids:
                self.positions_to_node_ids.put([i[2],i[3]],node_number)
                
            
                self.node_ids_to_positions.put(node_number,[i[2],i[3]])
               
           
                node_number = node_number + 1
        for i in self.poivector:
            if [i[0],i[1]] not in self.positions_to_node_ids:
                self.positions_to_node_ids.put([i[0],i[1]],node_number)
                self.node_ids_to_positions.put(node_number,[i[0],i[1]])
                node_number = node_number+1
        
        self.name_to_positions = HashTable(len(self.poivector), SboxHash64().hash)
        for i  in self.poivector:
           let name = i[3]
           let position = [i[0],i[1]]
           self.name_to_positions.put(name,position)
     
        self.graph = self.position_map()
        
    def find_route(self,src_lat,src_lon,dst_name):
        let sp = [src_lat,src_lon]
        let end_position =  self.name_to_positions.get(dst_name)
        let end =  self.positions_to_node_ids.get(end_position)
        
    #def path(sp,graph,end):
        let all_paths = self.shortest_paths(self.graph,sp).predicessors
        let route = Cons.Builder()
   
        if end == all_paths[end]:
            route = cons(all_paths[end],route)
        else:
            all_paths[end] = self.find_route (all_paths[end])
            route = cons(all_paths[end],route)

        
        return route
        
        
        
        
        
    def find_nearby(self,src_lat,src_lon,dst_cat,n):
         pass
    
   # def all_paths_finder(sp,graph):
       # let all_paths = shortest_paths(self.graph,sp).predicessors
     #   return all_paths
        
    def position_map(self):
        #let unique_vertices = self.unique_vertices_finder().len()
        let map = WuGraph(self.positions_to_node_ids.len())
        for i in self.rvector:
            map.set_edge( self.positions_to_node_ids.get([i[0],i[1]]),
            self.positions_to_node_ids.get([i[2],i[3]]),self.weight([i[0],i[1]],[i[2],i[3]]))
      
        return map
        
        
   
   
   
   
   
    def unique_vertices_finder(self):
        let node_number = 0
      
        for i in self.rvector:
            if [i[0],i[1]] not in self.positions_to_node_ids:
                self.positions_to_node_ids.put([i[0],i[1]],node_number)
                
            
                self.node_ids_to_positions.put(node_number,[i[0],i[1]])
               
                node_number = node_number + 1
            
            if [i[2],i[3]] not in self.positions_to_node_ids:
                self.positions_to_node_ids.put([i[2],i[3]],node_number)
                
            
                self.node_ids_to_positions.put(node_number,[i[2],i[3]])
               
           
                node_number = node_number + 1
        for i in self.poivector:
            if [i[0],i[1]] not in self.positions_to_node_ids:
                self.positions_to_node_ids.put([i[0],i[1]],node_number)
                self.node_ids_to_positions.put(node_number,[i[0],i[1]])
                node_number = node_number+1
        return  self.node_ids_to_positions
        
        #return node_number # not sure if there should be a return type. should it return
        #the two dictionariues and where do we use them
    def weight (self,a,b):
        return ((b[0]-a[0])**2 + (b[1]-a[1])**2).sqrt()
    
        
    def position_from_name (self,poivector): # chech name and where used to ensure no error
       for i  in self.poivector:
           let name = i[3]
           let position = [i[0],i[1]]
           self.name_to_positions.put(name,position)
      # return self.name_to_positions    # Again not totally sure if this is correct
           
    def shortest_paths(self,graph,start):
    
       let dist = [inf;self.graph.len()]
       let pred = [None;self.graph.len()]
       dist[start]= 0
       let todo = BinHeap[VecC[nat?, nat?]](graph.len(), λ x, y: x[1] < y[1])
       let done = [None;graph.len()]
       todo.insert([start,0])
       
       while todo.len()>0:
           let v = todo.find_min()
           todo.remove_min()# remove min has no return type
           
           if v not in done:
               done[v] = v
               let neighbours = graph.get_adjacent(v)
               let curr = neighbours
               while curr is not None:
                   if dist[v]+ graph.get_edge(v,curr)<dist[curr]:

                       dist[curr]=dist[v]+ graph.get_edge(v,curr)
                       pred[curr] = v
                       todo.insert([curr,dist[v]])#check line dist [input]
                   curr = curr.next   
       let pred_dist =   Dijkstra(pred,dist)               
       return pred_dist  # returns a list of predecessors.
            
               
               
              

           
           
    
#### ^^^ YOUR CODE HERE


def my_first_example():
    return TripPlanner([[0,0, 0,1], [0,0, 1,0]],
                       [[0,0, "bar", "The Empty Bottle"],
                        [0,1, "food", "Pelmeni"]])

test 'My first find_route test':
   assert my_first_example().find_route(0, 0, "Pelmeni") == \
       cons([0,0], cons([0,1], None))

test 'My first find_nearby test':
    assert my_first_example().find_nearby(0, 0, "food", 1) == \
        cons([0,1, "food", "Pelmeni"], None)

def example_from_handout():
    pass
#### ^^^ YOUR CODE HERE
