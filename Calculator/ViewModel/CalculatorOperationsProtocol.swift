import Foundation

enum Op : CustomStringConvertible {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
    case EmptyOperation(String, Double)

    var description: String {
        get {
            switch self {
            case .Operand(let operand):
                return "\(operand)"
            case .UnaryOperation(let symbol, _):
                return symbol
            case .BinaryOperation(let symbol, _):
                return symbol
            case .EmptyOperation(let symbol, _):
                return symbol
            }
        }
    }
}

protocol CalculatorOperationsProtocol {

    func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
}

extension CalculatorOperationsProtocol {

    func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainingOps)
                if let operand1 = operandEvaluation1.result {
                    let operandEvaluation2 = evaluate(operandEvaluation1.remainingOps)
                    if let operand2 = operandEvaluation2.result {
                        return (operation(operand1, operand2), operandEvaluation2.remainingOps)
                    }
                }
            case .EmptyOperation(_, let operation):
                return (operation, remainingOps)
            }
        }
        return(nil, ops)
    }
}
