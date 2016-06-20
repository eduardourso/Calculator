import Foundation
import RxSwift
import RxCocoa

public class CalculatorViewModel : CalculatorOperationsProtocol {

    public enum Operation {
        case Addition
        case Subtraction
        case Multiplication
        case Division
        case SquareRoot
    }
    
    private let displayText: BehaviorSubject<String> = BehaviorSubject(value: "")
    private let optStackSubject: BehaviorSubject<[Op]> = BehaviorSubject(value: [])
    private var knownOps = [Operation:Op]()
    private var userIsTypingNumber: Bool = false
    private var displayValue: Double {
        get {
            
            return NSNumberFormatter().numberFromString(displayTextString())!.doubleValue
        }
        set {
            if floor(newValue) == newValue {
               self.displayText.onNext("\(Int(newValue))")
            } else {
                self.displayText.onNext("\(newValue)")
            }
            self.userIsTypingNumber = false
        }
    }

    init() {
        knownOps[.Multiplication] = Op.BinaryOperation("x", *)
        knownOps[.Division] = Op.BinaryOperation("/") {$1 / $0}
        knownOps[.Subtraction] = Op.BinaryOperation("-") {$1 - $0}
        knownOps[.Addition] = Op.BinaryOperation("+", +)
        knownOps[.SquareRoot] = Op.UnaryOperation("√", sqrt)
    }

    func appendNumber(number: String) {
        if self.userIsTypingNumber {
            self.displayText.onNext(displayTextString() + number)
        } else {
            self.displayText.onNext(number)
            self.userIsTypingNumber = true
        }
    }

    func enter() {
        self.userIsTypingNumber = false

        if let result = pushOperand(self.displayValue) {
            self.displayValue = result
        } else {
            //todo display value it's gonna be optional
            self.displayValue = 0
        }
    }

    func calculate(operation: Operation) {
        if self.userIsTypingNumber {
            self.enter()
        }   
        if let result = performOperation(operation) {
            self.displayValue = result
        } else {
            self.displayValue = 0
        }
    }

    func pushOperand(operand: Double) -> Double? {
        self.optStackSubject.onNext(optStackSubjectArray() + Op.Operand(operand))
        return evaluate()
    }

    private func performOperation(symbol: Operation) -> Double? {
        if let operation = knownOps[symbol] {
            self.optStackSubject.onNext(optStackSubjectArray() + operation)
        }
        return evaluate()
    }

    private func evaluate() -> Double? {
        let (result, remainder) = evaluate(optStackSubjectArray())
        print("\(optStackSubjectArray()) = \(result) with \(remainder) left over")
        return result
    }

    func addDotToNumber(string: String) -> String {
        if (displayTextString().characters.count == 0) {
            self.displayText.onNext("0.")
        }
        else {
            if displayTextString().rangeOfString(".") == nil{
                self.displayText.onNext(displayTextString() + ".")
            }
        }
        return displayTextString()
    }

    func reset() {
        self.userIsTypingNumber = false
        self.optStackSubject.onNext([])
        self.displayValue = 0
        self.displayText.onNext("0")
    }
    
    func observableOptStack() -> Observable<[Op]> {
        return optStackSubject.asObservable()
    }
    
    func displayTextString() -> String {
        do {
            let displayTextString = try displayText.value()
            return displayTextString
        } catch {
            return ""
        }
    }
    
    func optStackSubjectArray() -> [Op] {
        do {
            let array = try optStackSubject.value()
            return array
        } catch {
            return []
        }
    }
}

func +<T>(a :[T], b :T) -> [T] {
    return a + [b]
}
