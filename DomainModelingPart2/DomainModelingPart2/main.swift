//
//  main.swift
//  DomainModelingPart2
//
//  Created by iGuest on 10/19/15.
//  Copyright (c) 2015 Alex Schenck. All rights reserved.
//

import Foundation

// Defines a necessity for human-readable string
protocol CustomStringConvertible
{
    var description : String { get }
}

// Defines a necessity for two mutating Money methods, add and subtract
protocol Mathematics
{
    mutating func add(otherMoney : Money)
    mutating func subtract(otherMoney : Money)
}

// Currency enumeration, double values represent relative conversion rates
enum Currency : Double
{
    case USD = 2
    case GBP = 1
    case EUR = 3
    case CAN = 2.5
}

struct Money : CustomStringConvertible, Mathematics
{
    var amount : Double
    var currency: Currency
    
    init(amount : Double, curr : Currency)
    {
        self.amount = amount
        self.currency = curr
    }
    
    var description : String
    {
        var currencyName : String
        
        switch currency
        {
            case .USD: currencyName = "USD"
            case .GBP: currencyName = "GBP"
            case .EUR: currencyName = "EUR"
            case .CAN: currencyName = "CAN"
        }
        
        return "\(currencyName)\(amount)"
    }
    
    // Returns given amount of given desired currency from given currency with amount
    func convert(toCurr : Currency) -> Double
    {
        return (self.currency.rawValue / toCurr.rawValue) * self.amount
    }
    
    // Conducts given math Operation and returns result in this Money's currency -- non mutating
    func mathOperation(op: String, otherMoney : Money) -> Double
    {
        switch op {
        case "add":
            return self.amount + otherMoney.convert(self.currency)
        case "subtract":
            return self.amount - otherMoney.convert(self.currency)
        default:
            println("Not a vaild operation")
            return 0
        }
    }
    
    // Adds given money to this money
    mutating func add(otherMoney: Money) {
        self.amount += otherMoney.convert(self.currency)
    }
    
    // Subtracts given money from this money
    mutating func subtract(otherMoney: Money) {
        self.amount -= otherMoney.convert(self.currency)
    }
}

// Test cases
var money1 = Money(amount: 15, curr: Currency.USD);
var money2 = Money(amount: 10, curr: Currency.CAN);
var money3 = Money(amount: 5, curr: Currency.GBP);
var money4 = Money(amount: 12, curr: Currency.EUR);

println("Money test cases")
println(money1.convert(Currency.EUR))
println(money2.convert(Currency.GBP))
println(money3.convert(Currency.CAN))
println(money4.convert(Currency.USD))
println(money1.mathOperation("add", otherMoney: money2))
println(money2.mathOperation("subtract", otherMoney: money3))
println(money1.mathOperation("add", otherMoney: money4))
println(money2.mathOperation("subtract", otherMoney: money1))
println(money1.description)
println(money2.description)
println(money3.description)
println(money4.description)

money1.add(money2)
println(money1.description)

money4.subtract(money1)
println(money4.description)

money2.add(money3)
println(money2)

class Job : CustomStringConvertible
{
    var title : String
    var salary : Double
    var salaryIsPerHour : Bool
    
    init (title : String, salary : Double, salaryIsPerHour : Bool)
    {
        self.title = title
        self.salary = salary
        self.salaryIsPerHour = salaryIsPerHour
    }
    
    var description : String
    {
        var payFrequency : String
        
        if salaryIsPerHour
        {
            payFrequency = "per hour"
        }
        else
        {
            payFrequency = "per year"
        }
        
        return "\(title), \(salary) \(payFrequency)"
    }
    
    // Returns calculated income based on given number of hours worked
    // If this job's salary is per year, hours worked can be nil
    func calculateIncome(hoursWorked : Double?) -> Double
    {
        if self.salaryIsPerHour == true
        {
            if hoursWorked != nil
            {
                return salary * hoursWorked!
            }
            else
            {
                return 0
            }
        }
        else
        {
            return salary
        }
    }
    
    // Increases salary by given percentage and returns new salary
    func raise(percentIncrease : Double) -> Double
    {
        self.salary += self.salary * (percentIncrease / 100)
        return self.salary
    }
}

// Test cases
var job1 = Job(title: "Developer", salary: 30, salaryIsPerHour: true)
var job2 = Job(title: "Designer", salary: 50000, salaryIsPerHour: false)

println("\nJob test cases")
println(job1.calculateIncome(200))
println(job1.raise(15))
println(job1.calculateIncome(200))
println(job2.calculateIncome(nil))
println(job2.raise(10))
println(job2.calculateIncome(nil))
println(job1.description)
println(job2.description)

class Person : CustomStringConvertible
{
    var firstName : String
    var lastName : String
    var age : Int
    var job : Job?
    var spouse : Person?
    
    init(firstName : String, lastName : String, age : Int, job : Job?, spouse : Person?)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        
        if age < 16
        {
            self.job = nil
            self.spouse = nil
        }
        else
        {
            self.job = job
            
            if age < 18
            {
                self.spouse = nil
            }
            else
            {
                self.spouse = spouse
            }
        }
    }
    
    var description : String
    {
        var jobName : String
        var spouseName : String
        
        if job == nil
        {
            jobName = "Jobless"
        }
        else
        {
            jobName = job!.title
        }
        
        if spouse == nil
        {
            spouseName = "Spouseless"
        }
        else
        {
            spouseName = "\(spouse!.firstName) \(spouse!.lastName)"
        }
        
        return "\(firstName) \(lastName), \(age), \(jobName), \(spouseName)"
    }
    
    // String representation of this person
    func toString() -> String
    {
        var result : String = ""
        result += "\(firstName) \(lastName) is \(age) years old.\n"
        
        if job == nil
        {
            result += "\(firstName) does not have a job.\n"
        }
        else
        {
            result += "\(firstName) is a \(job!.title).\n"
        }
        
        if spouse == nil
        {
            result += "\(firstName) is single."
        }
        else
        {
            result += "\(firstName)'s spouse is \(spouse!.firstName) \(spouse!.lastName)."
        }
        
        return result
    }
}

// Test cases
println("\nPerson test cases")
var Bob = Person(firstName: "Bob", lastName: "Smith", age: 45, job: nil, spouse: nil)
var Mary = Person(firstName: "Mary", lastName: "Smith", age: 43, job: job1, spouse: Bob)

println(Mary.toString())
println(Mary.description)

class Family : CustomStringConvertible
{
    var members : [Person]
    
    init(members : [Person])
    {
        var valid : Bool = false
        
        for var index = 0; index < members.count; index++
        {
            if members[0].age > 21
            {
                valid = true
            }
        }
        
        if valid == true
        {
            self.members = members
        }
        else
        {
            println("Family is not valid")
            self.members = []
        }
    }
    
    var description : String
    {
        var result : String = "Family members are:"
        
        for var index = 0; index < self.members.count; index++
        {
            result += " \(members[index].firstName) \(members[index].lastName)"
        }
        
        return result
    }
    
    // Returns combined income of all family members
    func householdIncome() -> Double
    {
        var result : Double = 0
        
        for var index = 0; index < self.members.count; index++
        {
            var currentJob : Job? = members[index].job
            
            if currentJob != nil
            {
                result += currentJob!.salary
            }
        }
        
        return result
    }
    
    // Appends new child with age of 0 with given name to family list
    func haveChild(firstName : String, lastName : String)
    {
        println("\(firstName) \(lastName) is born! Congrats!")
        members.append(Person(firstName: firstName, lastName: lastName, age: 0, job: nil, spouse: nil))
    }
}

// Test cases
println("\nFamily test cases")
var family1 = Family(members: [Bob, Mary])

println(family1.householdIncome())
family1.haveChild("Clyde", lastName: "Smith")
println(family1.description)