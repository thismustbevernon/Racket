j#lang dssl2
let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]

# HW5: Binary Heaps
#
# ** You must work on your own for this assignment. **

interface PRIORITY_QUEUE[X]:
    # Returns the number of elements in the priority queue.
    def len(self) -> nat?
    # Returns the smallest element; error if empty.
    def find_min(self) -> X
    # Removes the smallest element; error if empty.
    def remove_min(self) -> NoneC
    # Inserts an element; error if full.
    def insert(self, element: X) -> NoneC

# Class implementing the PRIORITY_QUEUE ADT as a binary heap.
class BinHeap[X] (PRIORITY_QUEUE):
    let _data: VecC[OrC(X, NoneC)]
    let _size: nat?
    let _lt?:  FunC[X, X, bool?]
    let capacity

    # Constructs a new binary heap with the given capacity and
    # less-than function for type X.
    def __init__(self, capacity, lt?):
        self.capacity = capacity
       
        self._data = [None;capacity]
        self._size = 0
        self._lt? = lt?
#### ^^^ YOUR CODE HERE

    def len(self):
        return self._size
#### ^^^ YOUR CODE HERE

    def insert(self, new_element):
        if (self.heap_full()):
            error ("the heap is full")
        self._data[self._size] = new_element
        self._size = self._size + 1
        self.bubble_up()
             
            
#### ^^^ YOUR CODE HERE

    def find_min(self):
        if (self._size == 0):
            error('the heap is empty')
        return self._data[0]
#### ^^^ YOUR CODE HERE

    def remove_min(self):
        if (self._size == 0):
            error('the heap is empty')
        
            
        self._data[0] = self._data[self._size -1]
        self._size = self._size - 1
        self.percolate_down()
#### ^^^ YOUR CODE HERE
        
        
## HELPER FUNCTIONS:
    def get_parent_Index(self,index):
        return (index)//2
        
    def get_leftChild_Index(self,index):
        return (2*index) + 1
        
    def get_rightChild_Index(self,index):
        return (2*index) + 2
    
    def has_parent(self,index):
        return self.get_parent_Index(index)>= 0
        
    def has_leftchild(self,index):
        return self.get_leftChild_Index(index) < self._size
        
    def has_rightchild(self,index):
        return self.get_rightChild_Index(index) < self._size
        
    def parent(self,index):
        return self._data[self.get_parent_Index(index)]
        
    def leftChild(self,index):
        return self._data[self.get_leftChild_Index(index)]
        
    def rightChild(self,index):
        return self._data[self.get_rightChild_Index(index)]
        
        
    def heap_full(self):
        return self._size == self.capacity
        
    def swap_values(self,index_1, index_2):
        let current = self._data [index_1]
        self._data[index_1] = self._data[index_2]
        self._data[index_2] = current
        
        
    def bubble_up (self):
        let index = self._size - 1
        while (self.has_parent(index) and self._lt?(self._data[index], self.parent(index))):
        #self.parent(index)>self._data[index]):
            self.swap_values(self.get_parent_Index(index),index)
            index = self.get_parent_Index(index)
    
    def percolate_down(self):
        let index = 0
        while(self.has_leftchild(index)):
            let smallerChild_index = self.get_leftChild_Index(index)
        
            if (self.has_rightchild(index) and self._lt?(self.rightChild(index), self.leftChild(index))):
                smallerChild_index = self.get_rightChild_Index(index)
         
            if self._lt?(self._data[index], self._data[smallerChild_index]):
                break
            
            else:
                self.swap_values (index,smallerChild_index)
            
            index = smallerChild_index
            
            
      
        
# Woefully insufficient test.
test 'insert, insert, remove_min':
    # The `nat?` here means our elements are restricted to `nat?`s.
    let h = BinHeap[nat?](10, λ x, y: x < y)
    h.insert(1)
    assert h.find_min() == 1
    
test "insert, len and find_min":
    let h = BinHeap[nat?](10, λ x, y: x < y)
    assert h.len() == 0
    h.insert(3)
    assert h.len() == 1
    assert h.find_min() == 3
    h.insert(4)
    assert h.find_min() == 3
    h.insert(1)
    assert h.find_min() == 1
    h.insert(10)
    assert h.len() == 4
    assert h.find_min() == 1
    
    ## This is to test remove_min:
    h.remove_min()
    assert h.len() == 3
    assert h.find_min() == 3
    h.insert(5)
    assert h.find_min() == 3
 
test " testing with equal values":
    let a = BinHeap[nat?](10, λ x, y: x < y)
    a.insert(3)
    a.insert(3)
    a.insert(10)
    a.insert(14)
    assert a.find_min() == 3
    a.remove_min()
    assert a.find_min() == 3
    a.remove_min()
    assert a.find_min() == 10
    
 
## Max_Heap Testing:
    
    
test "insert, len and find_min":
   let h = BinHeap[nat?](10, λ x, y: x > y)
   assert h.len() == 0
   h.insert(3)
   assert h.len() == 1
   assert h.find_min() == 3
   h.insert(4)
   assert h.find_min() == 4
   h.insert(1)
   assert h.find_min() == 4
   h.insert(10)
   assert h.len() == 4
   assert h.find_min() == 10
    
    ## This is to test remove_max:
   h.remove_min()
   assert h.len() == 3
   assert h.find_min() == 4
   h.insert(5)
   assert h.find_min() == 5

   
test " testing with equal values":
   let a = BinHeap[nat?](10, λ x, y: x > y)
   a.insert(5)
   a.insert(5)
   a.insert(10)
   a.insert(14)
   a.insert(2)
   a.insert(3)
   assert a.find_min() == 14
   a.remove_min()
   assert a.find_min() == 10
   a.remove_min()
   assert a.find_min() == 5
   a.remove_min()
   assert a.find_min() == 5
   a.remove_min()
   assert a.find_min() == 3
   
## EDGE Cases########################################
test "when heap is full":
   let h = BinHeap[nat?](5, λ x, y: x < y)
   assert h.len() == 0
   h.insert(1)
   h.insert(2)
   h.insert(3)
   h.insert(4) 
   h.insert(5)
   
   assert_error h.insert(6)
      
test "an empty vector":
   let h = BinHeap[nat?](10, λ x, y: x < y)
   assert h.len() == 0
   assert_error h.find_min() 
   assert_error h.remove_min() 
   
   
   ## Testing with max heap
   
   let c = BinHeap[nat?](10, λ x, y: x > y)
   assert c.len() == 0
   assert_error c.find_min() 
   assert_error c.remove_min() 
   
## Testing With STRINGS##################################################
   
test "Max Heap testing":
   let h = BinHeap(10, λ x, y: x > y)
   assert h.len() == 0
   h.insert('d')
   assert h.find_min() == 'd'
   assert h.len() == 1
   assert h.find_min() == 'd'
   h.insert('e')
   assert h.find_min() == 'e'
   h.insert('a')
   assert h.find_min() == 'e'
   h.insert("j")
   assert h.len() == 4
   assert h.find_min() == 'j'
    
   
 ## This is to test remove_maximum value:
   h.remove_min()
   assert h.len() == 3
   assert h.find_min() == 'e'
   h.insert('f')
   assert h.find_min() == 'f'
 
test " testing with equal values":
   let a = BinHeap[nat?](10, λ x, y: x < y)
   a.insert(3)
   a.insert(3)
   a.insert(10)
   a.insert(14)
   assert a.find_min() == 3
   a.remove_min()
   assert a.find_min() == 3
   a.remove_min()
   assert a.find_min() == 10
   
   

# Sorts a vector of Xs, given a less-than function for Xs.
#
# This function performs a heap sort by inserting all of the
# elements of v into a fresh heap, then removing them in
# order and placing them back in v.
def heap_sort[X](v: VecC[X], lt?: FunC[X, X, bool?]) -> NoneC:
    let Heap =  BinHeap(len(v), lt?)
    for i in range(len(v)):
        Heap.insert(v[i])
        
    for i in range(len(v)):
        v[i] = Heap.find_min()
        Heap.remove_min()
    
#### ^^^ YOUR CODE HERE

test 'heap sort descending':
    let v = [3, 6, 0, 2, 1]
    heap_sort(v, λ x, y: x > y)
    assert v == [6, 3, 2, 1, 0]

test 'heap sort ascending':
    let v = [3, 6, 0, 2, 1]
    heap_sort(v, λ x, y: x < y)
    assert v == [0, 1, 2, 3, 6]

    
test 'heap sort descending repeated values':
    let v = [3,3, 6, 0, 2, 1, 5, 5,5]
    heap_sort(v, λ x, y: x > y)
    assert v == [6,5,5,5,3,3, 2,1,0]
    
    
test "heap sort with string data type":
    let v = ["a", "b", "c", "d", 'e']
    heap_sort(v, λ x, y: x < y)
    assert v == ["a", 'b', "c", "d", "e"]

# Sorting by birthday.

struct person:
    let name: str?
    let birth_month: nat?
    let birth_day: nat?

def earliest_birthday() -> str?:
    let a = person("Sylvie", 8, 7)
    let b = person("Garielle",8,25)
    let c = person ("Francoise", 10,24)
    let d = person ( "julie ", 8, 12)
    let e = person("Jean-Roch",11,12)
    let f = person("Olivier", 6, 10)
    
    let v = [a,b,c,d,e,f]
    def compare_bdays (x,y):
        if x.birth_month == y.birth_month:
            return x.birth_day < y.birth_day
        else:
            return x.birth_month < y.birth_month
            
        
        
    heap_sort(v,compare_bdays)
    return v[0].name
    
#### ^^^ YOUR CODE HERE
test "earliest birthday":
    assert  earliest_birthday() == "Olivier"