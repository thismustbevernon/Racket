#lang dssl2
let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]

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
    let distances   #changed spelling
    
class TripPlanner (TRIP_PLANNER):
    let positions_to_node_ids 
    let node_ids_to_positions
    let name_to_positions
    let graph
    let rvector
    let poivector
    let pos_to_poi #new
    
    def __init__(self,roads,POI):
        self.rvector = roads
        self.poivector = POI
        let n_positions =  (2*self.rvector.len())+  self.poivector.len()
        self.positions_to_node_ids = HashTable(n_positions, SboxHash64().hash)
        self.node_ids_to_positions = HashTable(n_positions, SboxHash64().hash)
        self.unique_vertices_finder()
        self.pos_to_poi = HashTable(n_positions, SboxHash64().hash)
        self.positions_to_pois()#      
      
       
      
        
        self.name_to_positions = HashTable(len(self.poivector), SboxHash64().hash)
        self.position_from_name()
     
        self.graph = self.position_map()
        
    def find_route(self,src_lat,src_lon,dst_name):
        
        let sp = [src_lat,src_lon]
        
        let end_position =  self.name_to_positions.get(dst_name)
       
        let end =  self.positions_to_node_ids.get(end_position)
        
    #def path(sp,graph,end):
        let all_paths = self.shortest_paths(sp).predicessors
      

        
            
        let route = None
        route = cons (end_position,route)
        while self.shortest_paths(sp).predicessors[end]!= None:
            end = self.shortest_paths(sp).predicessors[end]
            route = cons(self.node_ids_to_positions.get(end),route)
        
        return route
        
        
        
        
        
    #def find_nearby(self,src_lat,src_lon,dst_cat,n):
         #pass
    
   # def all_paths_finder(sp,graph):
       # let all_paths = shortest_paths(self.graph,sp).predicessors
     #   return all_paths
        
    def position_map(self):
        #let unique_vertices = self.unique_vertices_finder().len()
        let map = WuGraph(self.positions_to_node_ids.len())
        for i in self.rvector:
            map.set_edge(self.positions_to_node_ids.get([i[0],i[1]]),
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
     
        
        #return node_number # not sure if there should be a return type. should it return
        #the two dictionariues and where do we use them
    def weight (self,a,b):
        return ((b[0]-a[0])**2 + (b[1]-a[1])**2).sqrt()
    
        
    def position_from_name (self): # chech name and where used to ensure no error
       for i  in self.poivector:
           let name = i[3]
           let position = [i[0],i[1]]
           self.name_to_positions.put(name,position)
      # return self.name_to_positions    # Again not totally sure if this is correct
           
    def shortest_paths(self,start):
       
       let dist = [inf;self.graph.len()]
       
       let pred = [None;self.graph.len()]
       
       let  vertex = self.positions_to_node_ids.get(start)
       
       dist[vertex]= 0
       
       let todo = BinHeap(self.graph.len(), λ x, y: dist[x] < dist[y])
       
       let done = [False;self.graph.len()]
       
       todo.insert(vertex)
       
       while todo.len()>0:
           
           let v = todo.find_min()
           
           todo.remove_min()# remove min has no return type
          
           if not done[v]:
               
               done[v] = True
               
               let neighbours = self.graph.get_adjacent(v)
               let curr = neighbours
               while curr is not None:
                   
                   if dist[v]+ self.graph.get_edge(v,curr.car)<dist[curr.car]:
                       
                       dist[curr.car]=dist[v]+ self.graph.get_edge(v,curr.car)
                       pred[curr.car] = v
                       todo.insert(curr.car)#check line dist [input]
                   curr = curr.cdr   
       let pred_dist =   Dijkstra(pred,dist)               
       return pred_dist  # returns a list of predecessors.
            
               
# Find nearby and related functions               
    def find_nearby(self,src_lat,src_lon,dst_cat,n):
       
         let sp = [src_lat,src_lon]
         let distance = self.shortest_paths(sp).distances
         let predicessorv =  self.shortest_paths(sp).predicessors
         let found_pois = None#
         
        
         let distance2 = self.sort(distance)
         
         let j = 0 
         while j < len(distance2) and n>0:
            
             let k = distance2[j]
             while predicessorv [k]!= None and n> 0:
               
                 if distance2[j] in self.node_ids_to_positions:
                    
                     if self.node_ids_to_positions.get(distance2[j]) in self.pos_to_poi:
                       
               
                         let pois =self.pos_to_poi.get(self.node_ids_to_positions.get(distance2[j]))
                         let i = 0
                         while i < pois.len() and n> 0: #changed used small for i
                             
                             if pois [i][2] == dst_cat:
                                 found_pois = cons(pois[i],found_pois)
                                 n = n-1
                     
                             i = i+1
                 k = predicessorv[k]
             j = j+1
         let found_pois_reversed = Cons.rev(found_pois)
             
         return  found_pois_reversed # create a linked list with the names of the pois

           
   
    
    def  positions_to_pois(self):#
       for poi in self.poivector:
           let position = [poi[0],poi[1]]
           if position in self.pos_to_poi:
               self.pos_to_poi[position].push_back(poi)
               
           else:
               self.pos_to_poi[position] = array()
               self.pos_to_poi[position].push_back(poi) 
    
    def sort(self,arr):
       let n = len(arr)
       let arr2 = [i for i in range (n)]
       for i in range(n-1):
           for j in range(0, n-i-1):
               if arr[arr2[j]] > arr[arr2[j + 1]] :
                   let temp = arr2[j] 
                   arr2[j] = arr2[j + 1]
                   arr2[j + 1] = temp
       return arr2   
     
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
