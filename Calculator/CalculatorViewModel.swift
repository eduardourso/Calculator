import Foundation

public struct CalculatorViewModel: CalculatorOperationsProtocol {

    private var userIsTypingNumber: Bool = false
    private var operandStack = Array<Double>()
    public var displayText: String = "0"

    public var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(self.displayText)!.doubleValue
        }

        set {
            self.displayText = "\(newValue)"
            self.userIsTypingNumber = false
        }
    }

    mutating func calculate(operation: Operation) {
        if self.userIsTypingNumber {
            self.enter()
        }
        if operandStack.count >= 2 {
            displayValue = operate(operandStack.removeLast(), opt2: operandStack.removeLast(), operation: operation)
            self.enter()
        }
    }

    mutating func appendNumber(number: String) {
        if self.userIsTypingNumber {
            self.displayText = displayText + number
        } else {
            self.displayText = number
            self.userIsTypingNumber = true
        }
    }

    mutating func enter() {
        self.userIsTypingNumber = false
        self.operandStack.append(self.displayValue)
        print("Operand Stack: \(self.operandStack)")
    }
}
