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
            "x":Operation.binaryOperation({$0 * $1}),
            "/":Operation.binaryOperation({$0 / $1}),
            "=":Operation.equals
    ]
    
    mutating func performOperation(_ symbol:String) {
        
        if let operation = operations[symbol]{
            switch operation {
                
            case .constant(let value):
                
                updateDescription(forOpWithSymbol: symbol)
                accumulator = value
                
            case .unaryOperation(let function):
                
                updateDescription(forOpWithSymbol: symbol)
                
                if accumulator != nil {
                    
                    accumulator = function(accumulator!)
                }
                
                unaryOperationUsed = true
                
            case .binaryOperation(let function):
                
                if accumulator != nil {
                    
                    updateDescription(forOpWithSymbol: symbol)
                    unaryOperationUsed = false
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    updateDescription(with: String(" \(symbol) "))
                }
                
            case .equals:
                
                updateDescription(forOpWithSymbol: symbol)
                performPendingBinaryOperation()
                
            }
            
        }
        
        
    }
    
    private mutating func performPendingBinaryOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
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
            case .constant: break
                
            case .unaryOperation:
                
                if descriptionString.characters.count>0 {
                    
                    if resultIsPending && accumulator != nil {
                        updateDescription(with: String("\(symbol)(\(accumulator!))"))
                    }else{
                        descriptionString = String("\(symbol)(\(descriptionString))")
                    }
                    
                }else{
                    
                    if accumulator != nil {
                        
                        updateDescription(with: String("\(symbol)(\(accumulator!))"))
                    }
                }
                
            case .binaryOperation:
                
                if accumulator != nil {
                    
                    if descriptionString.characters.count>0 {
                        
                    }else{
                        updateDescription(with: String("\(accumulator!)"))
                    }
                    
                }
                
            case .equals:
                
                if resultIsPending {
                    updateDescription(with: String("\(accumulator!)"))
                }
                
                
            }
            
        }
        
    }
    
    private mutating func updateDescription(with newStuff:String){
        
        if !unaryOperationUsed {
            descriptionString += newStuff
        }
        
    }
    
    var result: Double?{
        get{
            return accumulator
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
