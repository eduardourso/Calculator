import Foundation

enum Operation {
    case Addition
    case Subtraction
    case Multiplication
    case Division
}

protocol CalculatorOperationsProtocol {
    func operate(opt1: Double, opt2: Double, operation: Operation) -> Double
}

extension CalculatorOperationsProtocol {

    func operate(opt1: Double, opt2: Double, operation: Operation) -> Double {

        switch operation {
        case .Addition:
            return (opt1 + opt2)
        case .Subtraction:
            return (opt2 - opt1)
        case .Multiplication:
            return (opt1 * opt2)
        case .Division:
            return (opt2 / opt1)
        }
    }
}
