import Foundation
import RxSwift
import RxCocoa

class CalculatorViewModel : CalculatorOperationsProtocol {

    enum Operation {
        case Addition
        case Subtraction
        case Multiplication
        case Division
        case SquareRoot
        case Sin
        case Cos
        case Pi
    }

    var displayText = "0"
    var optStack = [Op]()
    let optStackSubject: BehaviorSubject<[Op]> = BehaviorSubject(value: [])
    private var knownOps = [Operation:Op]()
    private var userIsTypingNumber: Bool = false
    private var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(self.displayText)!.doubleValue
        }
        set {
            if floor(newValue) == newValue {
               self.displayText = "\(Int(newValue))"
            } else {
                self.displayText = "\(newValue)"
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
        knownOps[.Sin] = Op.UnaryOperation("sin", sin)
        knownOps[.Cos] = Op.UnaryOperation("cos", cos)
        knownOps[.Pi] = Op.EmptyOperation("π", M_PI)
    }

    func appendNumber(number: String) {
        if self.userIsTypingNumber {
            self.displayText = self.displayText + number
        } else {
            self.displayText = number
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
        self.optStack.append(Op.Operand(operand))
        self.optStackSubject.onNext(self.optStack)
        return evaluate()
    }

    private func performOperation(symbol: Operation) -> Double? {
        if let operation = knownOps[symbol] {
            self.optStack.append(operation)
            self.optStackSubject.onNext(self.optStack)
        }
        return evaluate()
    }

    private func evaluate() -> Double? {
        let (result, remainder) = evaluate(optStack)
        print("\(optStack) = \(result) with \(remainder) left over")
        return result
    }

    func addDotToNumber(string: String) -> String {
        if (self.displayText.characters.count == 0) {
            self.displayText = "0."
        }
        else {
            if self.displayText.rangeOfString(".") == nil{
                self.displayText = self.displayText + "."
            }
        }
        return self.displayText
    }

    func reset() {
        self.userIsTypingNumber = false
        self.optStack.removeAll()
        self.optStackSubject.onNext(self.optStack)
        self.displayValue = 0
        self.displayText = "0"
    }
}
