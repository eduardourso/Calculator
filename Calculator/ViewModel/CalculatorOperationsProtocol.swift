import Foundation

enum Op {
    case Operand(Double)
    case UnaryOperation(String, Double -> Double)
    case BinaryOperation(String, (Double, Double) -> Double)
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
                    return (operation(operand), remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainingOps)
                if let operand1 = operandEvaluation1.result {
                    let operandEvaluation2 = evaluate(operandEvaluation1.remainingOps)
                    if let operand2 = operandEvaluation2.result {
                        return (operation(operand1, operand2), operandEvaluation2.remainingOps)
                    }
                }
            }
        }
        return(nil, ops)
    }
}
