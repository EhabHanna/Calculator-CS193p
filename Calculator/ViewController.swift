//
//  ViewController.swift
//  Calculator
//
//  Created by Ehab Hanna on 8/6/17.
//  Copyright © 2017 Ehab Hanna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var operationsDisplay: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    var userEnteredFloat = false
   
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        switch digit {
        case ".":
            if userEnteredFloat{
                return
            }else{
                userEnteredFloat = true;
                if !userIsInTheMiddleOfTyping {
                    updateDisplayText(with: "0")
                }
                updateDisplayText(with: digit)
            }
        default:
            updateDisplayText(with: digit)
        }
        
        
    }
    
    private func updateDisplayText(with digit:String){
        
        let textCurrentlyInDisplay = display.text!
        
        if userIsInTheMiddleOfTyping {
            display.text = textCurrentlyInDisplay + digit
        }else{
            userIsInTheMiddleOfTyping = true
            display.text = digit
        }
    }
    
    private func updateOperationsDisplay(){
        if brain.resultIsPending {
            operationsDisplay.text = brain.description! + "..."
        }else{
            operationsDisplay.text = brain.description! + "="
        }
    }
    
    var displayValue :Double {
        
        get{
            return Double(display.text!)!
        }
        
        set{
            display!.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping{
            
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            userEnteredFloat = false
        
        }
        
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
            updateOperationsDisplay()
        }
        
        if let result = brain.result{
            displayValue = result
        }
    }

}

