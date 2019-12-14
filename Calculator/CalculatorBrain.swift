//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Ehab Hanna on 8/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private struct PendingBinaryOperation{
        let function: (Double,Double) -> Double
        let firstOperand:Double
        
        func perform(with secondOperand:Double) -> Double {
            return function(firstOperand,secondOperand)
        }
    }
    
    private var pendingBinaryOperation:PendingBinaryOperation?
    
    private let operations:Dictionary<String,Operation> =
        [
            "π": Operation.constant(Double.pi),
            "√":Operation.unaryOperation({sqrt($0)}),
            "cos":Operation.unaryOperation({cos($0)}),
            "sin":Operation.unaryOperation({sin($0)}),
            "tan":Operation.unaryOperation({tan($0)}),
            "±":Operation.unaryOperation({-$0}),
            "+":Operation.binaryOperation({$0 + $1}),
            "-":Operation.binaryOperation({$0 - $1}),
            "*":Operation.binaryOperation({$0 * $1}),
            "/":Operation.binaryOperation({$0 / $1}),
            "=":Operation.equals,
            "C":Operation.clear
    ]
    
    mutating func performOperation(_ symbol:String) {
        
        if let operation = operations[symbol]{
            switch operation {
                
            case .constant(let value):
                
                updateDescription(forOpWithSymbol: symbol)
                accumulator = value
                
            case .unaryOperation(let function):
                
                updateDescription(forOpWithSymbol: symbol)
                
                if let accumulator = accumulator{
                    
                    self.accumulator = function(accumulator)
                }
                
                unaryOperationUsed = true
                
            case .binaryOperation(let function):
                
                if let accumulator = accumulator {
                    
                    updateDescription(forOpWithSymbol: symbol)
                    unaryOperationUsed = false
                    
                    if pendingBinaryOperation != nil{
                        
                        updateDescription(with: String("\(accumulator)"))
                        performPendingBinaryOperation()
                    }
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator)
                    
                    self.accumulator = nil
                    updateDescription(with: String(" \(symbol) "))
                }
                
            case .equals:
                
                updateDescription(forOpWithSymbol: symbol)
                performPendingBinaryOperation()
                
            case .clear:
                accumulator = nil
                unaryOperationUsed = false
                pendingBinaryOperation = nil
                updateDescription(forOpWithSymbol: symbol)
            }
            
        }
        
        
    }
    
    private mutating func performPendingBinaryOperation(){
        if let pendingBinaryOperation = pendingBinaryOperation,
            let accumulator = accumulator {
            self.accumulator = pendingBinaryOperation.perform(with: accumulator)
            self.pendingBinaryOperation = nil
        }
        
    }
    
    mutating func setOperand(_ operand:Double) {
        
        accumulator = operand
        
        if !resultIsPending {
            descriptionString = ""
        }
    }
    
    private mutating func updateDescription(forOpWithSymbol symbol:String){
        
        if let operation = operations[symbol]{
            
            switch operation {
                
            case .constant(_):
                break
                
            case .unaryOperation(_):
                
                if descriptionString.count>0 {
                    
                    if resultIsPending && accumulator != nil {
                        updateDescription(with: String("\(symbol)(\(accumulator!))"))
                    }else{
                        descriptionString = String("\(symbol)(\(descriptionString))")
                    }
                    
                }else{
                    
                    if let accumulator = accumulator {
                        
                        updateDescription(with: String("\(symbol)(\(accumulator))"))
                    }
                }
                
            case .binaryOperation(_):
                
                if let accumulator = accumulator, descriptionString.isEmpty {
                    
                    updateDescription(with: String("\(accumulator)"))
                }
                
            case .equals:
                
                if resultIsPending, let accumulator = accumulator {
                    updateDescription(with: String("\(accumulator)"))
                }
                
            case .clear:
                descriptionString = ""
            }
            
        }
        
    }
    
    private mutating func updateDescription(with newStuff:String){
        
        if !unaryOperationUsed {
            descriptionString += newStuff
        }
        
    }
    
    public var result: Double?{
        get{
            guard let accumulator = accumulator else { return nil }
            let divisor = pow(10.0, Double(8))
            return (accumulator * divisor).rounded(.toNearestOrEven) / divisor
        }
    }
    
    public var resultIsPending: Bool{
        get{
            return pendingBinaryOperation != nil
        }
    }
    
    private var descriptionString: String = ""
    private var unaryOperationUsed:Bool = false
    
    public var description: String?{
        get{
            return descriptionString
        }
    }
    
}
