#lang dssl2

let eight_principles = ["Know your rights.",
     "Acknowledge your sources.",
     "Protect your work.",
     "Avoid suspicion.",
     "Do your own work.",
     "Never falsify a record or permit another person to do so.",
     "Never fabricate data, citations, or experimental results.",
     "Always tell the truth when discussing your work with your instructor."]


# HW1: DSSL2 Warmup
#
# ** You must work on your own for this assignment. **

###
### ACCOUNTS
###

# an Account is either a checking or a saving account
let account_type? = OrC("checking", "savings")

class Account:
    let id
    let type
    let balance

    # Account(nat?, account_type?, num?) -> Account?
    # Constructs an account with the given ID number, account type, and
    # balance. The balance cannot be negative.
    def __init__(self, id, type, balance):
        if balance < 0: error('Account: negative balance')
        if not account_type?(type): error('Account: unknown type')
        self.id = id
        self.type = type
        self.balance = balance

    # .get_balance() -> num?
    def get_balance(self): return self.balance

    # .get_id() -> nat?
    def get_id(self): return self.id

    # .get_type() -> account_type?
    def get_type(self): return self.type

    # .deposit(num?) -> NoneC
    # Deposits `amount` in the account. `amount` must be non-negative.
    def deposit(self, amount):
        if amount < 0: error('Please enter a valid amount.')
        self.balance = self.balance + amount

        
#   ^ FILL IN YOUR CODE HERE

    # .withdraw(num?) -> NoneC
    # Withdraws `amount` from the account. `amount` must be non-negative
    # and must not exceed the balance.
    def withdraw(self, amount):
        if amount < 0 or amount > self.balance: error('Please enter a valid amount.')
        self.balance = self.balance - amount
#   ^ FILL IN YOUR CODE HERE

    # .__eq__(Account?) -> bool?
    # Determines whether `self` and `other` are equal.
    def __eq__(self, other):
        if self.get_id() == other.get_id() and self.get_type() == other.get_type() and self.get_balance() == other.get_balance() :
            return True
        else:
            return False
#   ^ FILL IN YOUR CODE HERE

test 'Account#withdraw':
    let account = Account(2, "checking", 32)
    assert account.get_balance() == 32
    account.withdraw(10)
    assert account.get_balance() == 22
    assert_error account.withdraw(-10)
test 'Account#deposit':
    let account = Account(2, "checking", 32)
    assert account.get_balance() == 32
    account.deposit(10)
    assert account.get_balance() == 42
    assert_error account.deposit(-10)

test 'Account#__eq__':
    assert Account(5, "checking", 500) == Account(5, "checking", 500)
    


# account_transfer(num?, Account?, Account?) -> NoneC
# Transfers the specified amount from the first account to the second.
# That is, it subtracts `amount` from the `from` account’s balance and
# adds `amount` to the `to` account’s balance. `amount` must be non-
# negative.
def account_transfer(amount, from, to):
    if amount < 0 or amount > from.get_balance(): error('Please enter a valid amount.') 
    from.withdraw(amount)
    to.deposit(amount)
#   ^ FILL IN YOUR CODE HERE
test "account_transfer":
    let account_1 = Account(3, "checking",50)
    let account_2 = Account(5,"checking",10)
    
    assert_error (account_transfer(-10,account_1, account_2))
    assert_error (account_transfer(20,account_2, account_1))
    
    account_transfer(10,account_1, account_2)
    assert account_1.get_balance() == 40
    assert account_2.get_balance() == 20
    
   


###
### CUSTOMERS
###

# Customers have names and bank accounts.
struct customer:
    let name
    let bank_account

# max_account_id(VecC[customer?]) -> nat?
# Find the largest account id used by any of the given customers' accounts.
# Raise an error if no customers are provided.
def max_account_id(customers):
    if len(customers) == 0: error("Please enter customers")
    let largest_account_id = 0
    for customer in customers:
        if customer.bank_account.get_id()> largest_account_id:
            largest_account_id = customer.bank_account.get_id()
    return largest_account_id
        
#   ^ FILL IN YOUR CODE HERE
test "max_account_id":
    let customer_1 = customer('vernon', Account(3, "checking",14))
    let customer_2 = customer("ivy",Account(4,"savings",10))
    let customer_3 = customer("terrence", Account(5,"checking",14))
    let customer_vector = [customer_1, customer_2, customer_3]
   
    assert max_account_id(customer_vector) == 5
    assert_error max_account_id([])

# open_account(str?, account_type?, VecC[customer?]) -> VecC[customer?]
# Produce a new vector of customers, with a new customer added. That new
# customer has the provided name, and their new account has the given type and
# a balance of 0. The id of the new account should be one more than the current
# maximum, or 1 for the first account created.
def open_account(name, type, customers):
    if len(customers) == 0:
        return [customer(name,Account(1, type, 0))]
    else:
        let new_customer = customer(name, Account(max_account_id(customers) + 1, type, 0))
        let new_vector = vec(len(customers) + 1)
        for i in range(len(customers)):
            new_vector[i] = customers[i]
        
        new_vector [len(new_vector)-1]= new_customer
        return new_vector
    
test "open_account":
    let customer_1 = customer('jeff', Account(2, "checking", 32))
    let customer_2 = customer('vernon', Account(3, "savings", 0))
    let customer_3 = customer("ivy", Account(1,"savings",0))
    let customer_vector_1 = []
    let customer_vector_2 = [customer_1]
    assert open_account("ivy", "savings", customer_vector_1) == [customer_3]
    assert open_account('vernon', 'savings',customer_vector_2 ) == [customer_1, customer_2]
#   ^ FILL IN YOUR CODE HERE

# check_sharing(VecC[customer?]) -> bool?
# Checks whether any of the given customers share an account.
def check_sharing(customers):
    for i in range(len(customers)):
        for k in range((i+1),len(customers)):
            if customers[i].bank_account.get_id() == customers[k].bank_account.get_id():
                return True
    return False
        
        
#   ^ FILL IN YOUR CODE HERE
test "check_sharing":
    let customer_1 = customer('vernon', Account(3, "checking",14))
    let customer_2 = customer("ivy",Account(4,"savings",10))
    let customer_3 = customer("terrence", Account(3,"checking",14))
    let customer_vector_1 = [customer_1,customer_2,customer_3]
    let customer_vector_2 = [customer_1,customer_2]
    let customer_vector_3 = [customer_1,customer_3]
    assert check_sharing(customer_vector_1) == True
    assert check_sharing(customer_vector_2) == False
    assert check_sharing(customer_vector_3)== True