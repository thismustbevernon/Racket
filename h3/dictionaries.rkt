#lang dssl2

let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]


# HW3: Dictionaries
#
# ** You must work on your own for this assignment. **

import sbox_hash

# A signature for the dictionary ADT. The contract parameters `K` and
# `V` are the key and value types of the dictionary, respectively.
interface DICT[K, V]:
    # Returns the number of key-value pairs in the dictionary.
    def len(self) -> nat?
    # Is the given key mapped by the dictionary?
    def mem?(self, key: K) -> bool?
    # Gets the value associated with the given key; calls `error` if the
    # key is not present.
    def get(self, key: K) -> V
    # Modifies the dictionary to associate the given key and value. If the
    # key already exists, its value is replaced.
    def put(self, key: K, value: V) -> NoneC
    # Modifes the dictionary by deleting the association of the given key.
    def del(self, key: K) -> NoneC
    # The following three methods connect the `_ in _`, `_[_]` and
    # `_[_] = _` operators (as used in the example test below) to
    # your method implementations above. That is, when `h` is a
    # `DICT` then:
    #   - `k in h`    means  `h.mem?(k)`
    #   - `h[k]`      means  `h.get(k)`
    #   - `h[k] = v`  means  `h.put(k, v)`
    def __contains__(self, key: K)
    def __index_ref__(self, key: K)
    def __index_set__(self, key: K, value: V)

struct _dict:
    let key
    let value 
    let next
    

class AssociationList[K, V] (DICT):
    let head
    let length
  

    #   ^ YOUR FIELDS HERE

    def __init__(self):
        self.head = None
        self.length = 0
    #   ^ YOUR DEFINITION HERE

    def len(self) -> nat?:
        return self.length
    #   ^ YOUR DEFINITION HERE

    def mem?(self, key: K) -> bool?:
        let curr = self.head
        while curr is not None:
            if curr.key == key:
                return True
            curr = curr.next
        return False
      
    #   ^ YOUR DEFINITION HERE

    def get(self, key: K) -> V:
        let curr = self.head
        while curr is not None:
            if curr.key == key:
                return curr.value
            curr = curr.next
        error("key not found")
        
    #   ^ YOUR DEFINITION HERE

    def put(self, key: K, value: V) -> NoneC:
        let curr = self.head
        while curr is not None:
            if curr.key == key:
                curr.key = key
                curr.value = value
                return 
            curr = curr.next
        self.head =  _dict(key,value,self.head)
        self.length = self.length + 1
    #   ^ YOUR DEFINITION HERE

    def del(self, key: K) -> NoneC:
        let curr = self.head
        if curr == None:
            return
        if curr.key == key:
            self.head = self.head.next
            self.length = self.length -1 
      
        let prev = self.head
        curr = curr.next
        while curr is not None:
            if curr.key == key:
                prev.next = curr.next
                self.length = self.length -1 
            
            curr = curr.next
            prev = prev.next
       
        
    #   ^ YOUR DEFINITION HERE

    # See above.
    def __contains__(self, key): self.mem?(key)
    def __index_ref__(self, key): self.get(key)
    def __index_set__(self, key, value): self.put(key, value)

test 'yOu nEeD MorE tEsTs':
    let a = AssociationList()
    assert 'hello' not in a
    a['hello'] = 5
    assert a.len() == 1
    assert 'hello' in a
    assert a['hello'] == 5
    
test "length":
    let b = AssociationList()
    assert b.len() == 0
    b.put("Dorcas",4)
    b.put("Doreen",4)
    b.put("Edna",5)
    assert b.len() == 3
    
test 'put items':
    let b = AssociationList()
    assert b.len() == 0
    b.put("Angela",1)
    assert b.len() == 1
    b.put("Betty",2)
    b.put("Cindy",3)
    b.put("Dorcas",4)
    b.put("Doreen",4)
    b.put("Edna",5)
    assert b.len() == 6
    assert b.get("Doreen") == 4
    b.put("Doreen",8)
    assert b.len() == 6
    assert b.get("Doreen") == 8
    assert b.mem?("Dorcas") == True
test "GET items":
    let c = AssociationList()
    assert_error c.get("Diana")
    c.put("Betty",2)
    c.put("Cindy",3)
    c.put("Cindy",3)
    c.put("Diana",4)
    c.put("Joy",5)
    assert c.len() == 4
    assert c.get("Diana") == 4
    c.del("Diana")
    assert c.len() == 3
    assert_error c.get("Diana")
    
test "DELETE items":
    let c = AssociationList()
    c.del('Eva')
    c.put("Betty",2)
    c.put("Cindy",3)
    c.put("Clara",3)
    c.put("Cynthia",9)
    assert c.mem?("Cynthia") == True
    c.put("Diana",4)
    c.put("Edith",5)
    assert c.len() == 6
    c.del("Betty")
    assert c.len() == 5
    c.del("Cynthia")
    assert c.len() == 4
    c.del("Edith")
    assert c.len() == 3
    assert c.mem?("Cynthia") == False
test "mem? item ":
    let c = AssociationList()
    assert c.mem?('Diana') == False
    c.put("Betty",2)
    c.put("Clara",3)
    c.put("Diana",4)
    c.put("Mishel",5)
    assert c.mem?('Diana') == True
    assert c.mem?('Liz') == False
    c.del("Diana")
    assert c.mem?('Diana') == False
   
class HashTable[K, V] (DICT):
    let _hash
    let _size
    let _data

    def __init__(self, nbuckets: nat?, hash: FunC[AnyC, nat?]):
        self._hash = hash
        self._size = 0
        self._data = [None;nbuckets ]
        for i in range(nbuckets):
            self._data[i] = AssociationList()
            i = i+1
        
    def _initial_bucket_index(self, key: K) -> nat?:
        return self._hash(key) % self._data.len()

  
    #   ^ THE REST OF YOUR DEFINITION HERE

    def len(self) -> nat?:
        return self._size
    #   ^ YOUR DEFINITION HERE

    def mem?(self, key: K) -> bool?:
       
       self._data[self._initial_bucket_index(key) ].mem?(key)
    #   ^ YOUR DEFINITION HERE

    def get(self, key: K) -> V:
       
       return self._data[self._initial_bucket_index(key) ].get(key)
    #   ^ YOUR DEFINITION HERE

    def put(self, key: K, value: V) -> NoneC:
        if self._data[self._initial_bucket_index(key) ].mem?(key):
             self._data[self._initial_bucket_index(key) ].put(key,value)
        else:
             self._data[self._initial_bucket_index(key) ].put(key,value)
             self._size = self._size + 1
    #   ^ YOUR DEFINITION HERE

    def del(self, key: K) -> NoneC:
       if self._data[self._initial_bucket_index(key) ].mem?(key):
            self._data[self._initial_bucket_index(key) ].del(key)
            self._size = self._size - 1
       else:
            pass
    #   ^ YOUR DEFINITION HERE

    # This avoids trying to print the hash function, since it's not really
    # printable and isn’t useful to see anyway:
    def __print__(self, print):
        print("#<object:HashTable  _hash=... _size=%p _data=%p>",
              self._size, self._data)

    # See above.
    def __contains__(self, key): self.mem?(key)
    def __index_ref__(self, key): self.get(key)
    def __index_set__(self, key, value): self.put(key, value)


# first_char_hasher(String) -> Natural
# A simple and bad hash function that just returns the ASCII code
# of the first character.
# Useful for debugging because it's easily predictable.
def first_char_hasher(s: str?) -> int?:
    if s.len() == 0:
        return 0
    else:
        return int(s[0])

test 'yOu nEeD MorE tEsTs, part 2':
    let h = HashTable(10, SboxHash64().hash)
    assert 'hello' not in h
    h['hello'] = 5
    assert h.len() == 1
    assert 'hello' in h
    assert h['hello'] == 5

test "length":
    let b =  HashTable(10, SboxHash64().hash)
    assert b.len() == 0
    b.put("Dorcas",4)
    b.put("Doreen",4)
    b.put("Edna",5)
    assert b.len() == 3 
    
test 'put items, part 2':
    let b = HashTable(10, SboxHash64().hash)
    assert b.len() == 0
    b.put("Angela",1)
    assert b.len() == 1
    b.put("Betty",2)
    b.put("Cindy",3)
    b.put("Dorcas",4)
    b.put("Doreen",4)
    b.put("Edna",5)
    assert b.len() == 6
    assert b.get("Doreen") == 4
    b.put("Doreen",8)
    assert b.len() == 6
    assert b.get("Doreen") == 8
    assert b.mem?("Dorcas") == True
    
test "GET items, part 2":
    let c = HashTable(10, SboxHash64().hash)
    assert_error c.get("Diana")
    c.put("Betty",2)
    c.put("Cindy",3)
    c.put("Cindy",3)
    c.put("Diana",4)
    c.put("Joy",5)
    assert c.len() == 4
    assert c.get("Diana") == 4
    c.del("Diana")
    assert c.len() == 3
    assert_error c.get("Diana")
    
test "DELETE items part 2":
    let c = HashTable(10,first_char_hasher)
    c.del('Eva')
    c.put("Betty",2)
    c.put("Cindy",3)
    c.put("Clara",3)
    c.put("Cynthia",9)
    assert c.mem?("Cynthia") == True
    c.put("Diana",4)
    c.put("Edith",5)
    assert c.len() == 6
    c.del("Betty")
    assert c.len() == 5
    c.del("Cynthia")
    assert c.len() == 4
    c.del("Edith")
    assert c.len() == 3
    assert c.mem?("Cynthia") == False
    
test "mem? item part 2":
    let c =  HashTable(10,first_char_hasher)
    assert c.mem?('Diana') == False
    c.put("Betty",2)
    c.put("Clara",3)
    c.put("Diana",4)
    c.put("Mishel",5)
    assert c.mem?('Diana') == True
    assert c.mem?('Liz') == False
    c.del("Diana")
    assert c.mem?('Diana') == False
    
test "fisrt char hasher" :
     let c = HashTable(10,first_char_hasher)
     c["B"] = 2
     c.put("C",3)
     c.put("D",4)
     c.put("E",5)
     assert c.len() == 4
     assert c.get("D") == 4
     c.del("D")
     assert c.len() == 3
     assert_error c.get("D")
     
test 'FC Hasher put items':
    let b = HashTable(4,first_char_hasher)
    assert b.len() == 0
    b.put("Angela",1)
    assert b.len() == 1
    b.put("Betty",2)
    b.put("Cindy",3)
    b.put("Clara",8)
    b.put("Cynthia",6)
    b.put("Dorcas",4)
    b.put("Doreen",4)
    assert b.len() == 7
    assert b.get("Doreen") == 4
    b.put("Doreen",8)
    assert b.len() == 7
    assert b.get("Doreen") == 8
    assert b.mem?("Dorcas") == True
    
test "FC Hasher DELETE items":
    let c =  HashTable(10,first_char_hasher)
    c.del('Eva')
    c.put("Betty",2)
    c.put("Cindy",3)
    c.put("Clara",3)
    c.put("Cynthia",9)
    assert c.mem?("Cynthia") == True
    c.put("Diana",4)
    c.put("Edith",5)
    assert c.len() == 6
    c.del("Betty")
    assert c.len() == 5
    c.del("Cynthia")
    assert c.len() == 4
    c.del("Edith")
    assert c.len() == 3
    assert c.mem?("Cynthia") == False

struct fav_dish:
    let cuisine
    let origin
    
    

def compose_menu(d: DICT!) -> DICT?:
    let sushi = fav_dish("Sushi", "Japanese")
    let masala_dosa = fav_dish("Masala dosa", "Indian")
    let apple_pie = fav_dish ("Apple pie", "American ")
    let pizza = fav_dish ("pizza", "Italian")
    let channa_masala = fav_dish( "Channa masala", "Indian")
    let pupusas = fav_dish ("Pupusas", "Salvadoran ")
    
    
    
    d["Jesse"] = sushi
    d['Stevie']= masala_dosa
    d['Branden']= apple_pie
    d['Steve']= pizza
    d['Sara']= channa_masala
    d['Iliana']= pupusas
    
    return d

#   ^ YOUR DEFINITION HERE

test "AssociationList menu":
    let d = AssociationList()
    compose_menu(d)
    assert  d['Sara'].cuisine == "Channa masala"

test "HashTable menu":
    let d = HashTable(10, SboxHash64().hash)
    compose_menu(d)
    assert  d['Sara'].cuisine == "Channa masala"
