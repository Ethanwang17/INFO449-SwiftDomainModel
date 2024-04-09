struct DomainModel {
    var text = "Hello, World!"
    // Leave this here; this value is also tested in the tests,
    // and serves to make sure that everything is working correctly
    // in the testing harness and framework.
}

////////////////////////////////////
// Money

public struct Money {
    var amount: Int
    var currency: String
    
    init(amount: Int, currency: String) {
        if !["USD", "GBP", "EUR", "CAN"].contains(currency) {
            fatalError("Unknown currency: \(currency)")
        }
        self.amount = amount
        self.currency = currency
    }
    func convert(_ newCurrency: String) -> Money {
        var usdAmount: Int
        
        switch currency {
        case "USD":
            usdAmount = amount
            
        case "GBP":
            usdAmount = Int(Double(amount) / 0.5)
            
        case "EUR":
            usdAmount = Int(Double(amount) / 1.5)
            
        case "CAN":
            usdAmount = Int(Double(amount) / 1.25)
            
        default:
            fatalError("Unknown currency: \(currency)")
            
        }
        
        
        switch newCurrency {
        case "USD":
            return Money(amount: usdAmount, currency: newCurrency)
            
        case "GBP":
            return Money(amount: Int(Double(usdAmount) * 0.5), currency: newCurrency)
            
        case "EUR":
            return Money(amount: Int(Double(usdAmount) * 1.5), currency: newCurrency)
            
        case "CAN":
            return Money(amount: Int(Double(usdAmount) * 1.25), currency: newCurrency)
            
        default:
            fatalError("Unknown currency: \(newCurrency)")
        }
    }
    
    
    func add(_ moneyAdd: Money) -> Money{
        var convertAmount = moneyAdd.amount
        if (currency != moneyAdd.currency) {
            let convertCurr = convert(moneyAdd.currency)
            convertAmount += convertCurr.amount
        } else {
            convertAmount += amount
        }
        return Money(amount: convertAmount, currency: moneyAdd.currency)
    }
    
    
    func subtract(_ moneySub: Money) -> Money{
        var convertAmount = moneySub.amount
        if (currency != moneySub.currency) {
            let convertCurr = convert(moneySub.currency)
            convertAmount -= convertCurr.amount
        } else {
            convertAmount -= amount
        }
        return Money(amount: convertAmount, currency: moneySub.currency)
    }
}

////////////////////////////////////
// Job

public class Job {
    var title: String
    var type: JobType
    
    enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let wage):
            return Int(wage * Double(hours))
        case .Salary(let salary):
            return salary
        }
    }
    
    func raise(byAmount amount: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage + Double(amount))
        case .Salary(let salary):
            type = .Salary(salary + Int(amount))
        }
    }
    
    func raise(byPercent percentage: Double) {
        switch type {
        case .Hourly(let wage):
            type = .Hourly(wage * (1 + percentage))
        case .Salary(let salary):
            type = .Salary(Int(Double(salary) * (1 + percentage)))
        }
    }
}


////////////////////////////////////
// Person

public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if age < 16 {
                job = nil
            }
        }
    }
    var spouse: Person? {
        didSet {
            if age < 16 {
                spouse = nil
            }
        }
    }
    
    init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        var result = "[Person: firstName:" + firstName + " lastName:" + lastName + " age:" + String(age) + " job:"
        if job != nil {
            result += job!.title
        } else {
            result += "nil"
        }
        result += " spouse:"
        if spouse != nil {
            result += spouse!.firstName
        } else {
            result += "nil"
        }
        result += "]"
        return result
    }
}





////////////////////////////////////
// Family

public class Family {
    var members : [Person] = []
    
    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    func haveChild(_ kid: Person) -> Bool {
        if members[0].age > 21 || members[1].age > 21 {
            members.append(kid)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int {
        var famIncome = 0
        for person in members{
            let work = person.job
            if (work !== nil) {
                famIncome += work!.calculateIncome(2000)
            }
        }
        return famIncome
    }
}
