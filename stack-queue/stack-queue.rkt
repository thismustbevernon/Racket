#lang dssl2

let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]


# HW2: Stacks and Queues
#
# ** You must work on your own for this assignment. **

interface STACK[T]:
    def push(self, element: T) -> NoneC
    def pop(self) -> T
    def empty?(self) -> bool?

interface QUEUE[T]:
    def enqueue(self, element: T) -> NoneC
    def dequeue(self) -> T
    def empty?(self) -> bool?

# Linked-list node struct (implementation detail):
struct _node:
    let data
    let next: OrC(_node?, NoneC)

###
### ListStack
###

class ListStack (STACK):

    # Any fields you may need can go here.
    let head

    # Constructs an empty ListStack.
    def __init__ (self):
        self.head = None
    #   ^ YOUR DEFINITION HERE

    # Other methods you may need can go here.
    def push(self, element):
        self.head = _node(element, self.head)
        
    def pop (self):
        if self.head == None:
            error("stack is empty")
        else:
            let curr = self.head.data
            self.head = self.head.next
            return curr 
        
    def empty?(self):
        return self.head == None
    

test "woefully insufficient":
    let s = ListStack()
    s.push(2)
    assert s.pop() == 2
    assert_error s.pop()
    assert s.empty?()
    s.push(4)
    s.push(5)
    s.push(6)
    assert s.pop() == 6
    assert s.pop() == 5
    assert s.pop() == 4

###
### ListQueue
###

class ListQueue (QUEUE):

    # Any fields you may need can go here.
    let head
    let tail

    # Constructs an empty ListQueue.
    def __init__ (self):
        self.head = None
        self.tail = None
    #   ^ YOUR DEFINITION HERE

    # Other methods you may need can go here.
    def enqueue (self,element):
        if self.head == None:
            self.head = _node(element,self.head)
            self.tail = self.head
        else:
            self.tail.next = _node(element, None)
            self.tail = self.tail.next
           
    
    def dequeue (self):
        if self.head == None:
            error( "queue is empty")
        else:
            let curr = self.head.data
            self.head = self.head.next
            return curr
        
    def empty?(self):
        return self.head == None
    


test "woefully insufficient, part 2":
    let q = ListQueue()
    q.enqueue(2)
    assert q.dequeue() == 2
    assert_error q.dequeue()
    assert q.empty?()
    q.enqueue(4)
    q.enqueue(5)
    q.enqueue(6)
    assert q.dequeue() == 4
    assert q.dequeue() == 5
    assert q.dequeue() == 6
    

###
### Playlists
###

# Please include the RingBuffer class from Canvas here.

struct song:
    let title: str?
    let artist: str?
    let album: str?

# Enqueue five songs of your choice to the given queue, then return the first
# song that should play.
let song_1 = song("Stop Them Jah", "Augustus Pablo","King Tubbys Meets Rockers Uptown" )
let song_2 = song( "Horology", "King Gizzard & the Lizard Wizard","Polygondwanaland")
let song_3 = song("FuzzGongFight","XiuXiu","OHNO")
let song_4 = song( "Mo is On", "Elmo Hope", "Trio and Quintet")
let song_5 = song( "Storm", "Godspeed You! Black Emperor"," Lift Your Skinny Fists Like Antennas to Heaven!" )

def fill_playlist (q: QUEUE!):
    q.enqueue(song_1)
    q.enqueue(song_2)
    q.enqueue(song_3)
    q.enqueue(song_4)
    q.enqueue(song_5)
    
    return q.dequeue()
    

    
#   ^ YOUR DEFINITION HERE

test "ListQueue playlist":
    let test_queue = ListQueue()
    assert fill_playlist(test_queue) == song_1
    assert test_queue.dequeue() == song_2
    

    
class RingBuffer[T] (QUEUE):
    let data
    let start
    let size

    def __init__(self, capacity):
        self.data = [None; capacity]
        self.start = 0
        self.size = 0

    def capacity(self):
        return self.data.len()

    def len(self):
        return self.size

    def empty?(self):
        return self.len() == 0

    def full?(self):
        return self.len() == self.capacity()

    def enqueue(self, element: T):
        if self.full?(): error('RingBuffer.enqueue: full')
        self.data[(self.start + self.size) % self.capacity()] = element
        self.size = self.size + 1

    def dequeue(self) -> T:
        if self.empty?(): error('RingBuffer.dequeue: empty')
        let result = self.data[self.start]
        self.data[self.start] = None
        self.size = self.size - 1
        self.start = (self.start + 1) % self.capacity()
        return result
    
test "RingBuffer playlist":
    let test_queue = RingBuffer(7)
    assert fill_playlist(test_queue) == song_1
    assert test_queue.dequeue() == song_2
    