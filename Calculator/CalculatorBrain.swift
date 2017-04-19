//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by yujie zhang on 2017-04-10.
//  Copyright © 2017 Jay Zhang. All rights reserved.
//

import Foundation


extension Double {
    static let minTwoMaxSixDigits: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        return formatter
    }()
    var formatted: String {
        return Double.minTwoMaxSixDigits.string(for: self) ?? ""
    }
}




struct CalculatorBrain {
    
    private var accumulator: (Double, String)?
    
    private enum  Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double, Double) -> Double, (String, String) -> String)
        case equals
        case clear
    }
    
    
    private var operations: Dictionary<String, Operation> = [
    "π" : Operation.constant(Double.pi),
    "e" : Operation.constant(M_E),
    
    
    "∛" : Operation.unaryOperation({pow($0,1/3)}, {"∛(" + $0 + ") "}),
    "∜" : Operation.unaryOperation({pow($0,1/4)}, {"∜(" + $0 + ") "}),
    "√" : Operation.unaryOperation(sqrt, {"√(" + $0 + ") "} ),
    "cos" : Operation.unaryOperation(cos, {"cos(" + $0 + ") "}),
    "sin" : Operation.unaryOperation(sin, {"sin(" + $0 + ") "}),
    "%" : Operation.unaryOperation({$0 / 100}, {"(" + $0 + ")% "}),
    "x²" : Operation.unaryOperation({pow($0, 2)}, {"(" + $0 + ")² "}),
    "x³" : Operation.unaryOperation({pow($0, 3)}, {"(" + $0 + ")³ "}),
    "±" : Operation.unaryOperation({-$0}, {"-(" + $0 + ") "}),
    
    
    "xʸ" : Operation.binaryOperation({pow($0, $1)}, { $0 + " ^ " + $1 }),
    "×" : Operation.binaryOperation({$0 * $1}, { $0 + " x " + $1}),
    "÷" : Operation.binaryOperation({$0 / $1}, { $0 + " ÷ " + $1}),
    "+" : Operation.binaryOperation({$0 + $1}, { $0 + " + " + $1}),
    "−" : Operation.binaryOperation({$0 - $1}, { $0 + " − " + $1}),
    "=" : Operation.equals,
    "c" : Operation.clear
    ]
    
    var description: String? {
        get {
            if resultIsPending {
                 return pendingBinaryOperation!.description(pendingBinaryOperation!.firstOperand.1, accumulator?.1 ?? "")
            } else {
                return accumulator?.1
            }
        }
    }
    
    mutating func performOperation(_ symbol: String){
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = (value, symbol)
                
            case .unaryOperation(let function, let description):
                if accumulator != nil {
                    accumulator = (function(accumulator!.0), description(accumulator!.1) )
                }
            case .binaryOperation(let function, let description):
                if accumulator  != nil{
                    
                    if resultIsPending {
                        performPendingBinaryOperation()
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function,description: description, firstOperand: accumulator!)
                    accumulator = nil
                }
                
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                cleanup()
                
            }
        }
        
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator =  pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    var resultIsPending: Bool {
        return (pendingBinaryOperation == nil) ? false : true
    }
    
   
   
    
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let description: (String, String) -> String
        let firstOperand :(Double, String)
        
        func perform(with secondOperand: (Double, String)) -> (Double, String) {
            return (function(firstOperand.0, secondOperand.0), description(firstOperand.1, secondOperand.1))
        }
    }
    
    mutating func setOperand(_ operand: Double){
        accumulator = (operand, String(operand.formatted))
        
    }
    
    var result: Double? {
        get {
            return accumulator?.0
        }
    }
    
    private mutating func cleanup(){
        accumulator = nil
    }
    
}
