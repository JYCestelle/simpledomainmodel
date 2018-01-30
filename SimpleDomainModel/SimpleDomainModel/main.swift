//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
// init
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }

  
  public func convert(_ to: String) -> Money {
    var amount = 0
    switch (currency, to) {
    case ("USD", "GBP"):
        amount = self.amount / 2
    case("USD", "EUR"):
        amount = Int(Double(self.amount) * 1.5)
    case("USD", "CAN"):
        amount = Int(Double(self.amount) * 1.25)
    case("GBP", "USD"):
        amount = self.amount * 2
    case("EUR", "USD"):
        amount = Int(Double(self.amount) / 1.5)
    case("CAN", "USD"):
        amount = Int(Double(self.amount) / 1.25)
    default:
        amount = self.amount
    }
    return Money(amount: amount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    var current = self
    if (to.currency != current.currency) {
        current = current.convert(to.currency)
    }
    let newAmount = to.amount + current.amount
    return Money(amount: newAmount, currency: current.currency)
  }
  public func subtract(_ from: Money) -> Money {
    var current = self
    if currency != from.currency{
        current = self.convert(from.currency)
    }
    return Money(amount: current.amount - from.amount, currency: from.currency)
  }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
    case .Hourly(let income):
        return Int(income * Double(hours))
    case .Salary(let income):
        return income
    }
  }
  
  open func raise(_ amt : Double) {
        switch self.type {
        case .Hourly(let hourlyWage):
            self.type = JobType.Hourly(hourlyWage + amt)
        case .Salary(let yearlySalary):
            self.type = JobType.Salary(Int(Double(yearlySalary) + amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

  fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if age >= 21 {
                _job = value
            }
        }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        return _spouse
    }
    set(value) {
        if age >= 21 {
            _spouse = value
        }
    }
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: _job)) spouse:\(String(describing: _spouse))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    spouse1.spouse = spouse2
    spouse2.spouse = spouse1
    members.append(spouse1)
    members.append(spouse2)
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age >= 21 || members[1].age >= 21 {
        members.append(child)
        return true
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var total = 0
    for member in members {
        if member.job != nil {
            total += member._job!.calculateIncome(2000)
        }
    }
    return total
  }
}





