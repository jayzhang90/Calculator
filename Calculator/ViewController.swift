//
//  ViewController.swift
//  Calculator
//
//  Created by yujie zhang on 2017-04-05.
//  Copyright © 2017 Jay Zhang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // ! means implicit unwrap, which means even though display
    // is an optional, but when use it everywhere else, it upwraps
    // automatically
 
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var descriptionDisplay: UILabel!
   
    
    var userInTheMiddleOfTyping = false
    
    @IBAction func backSpaceAction(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            print("backSpack")
            switch display.text!.characters.count {
            case 0: break
            case 1: displayValue = 0
                    userInTheMiddleOfTyping = false
                    break
            default:
                // remove the last digit
            var titleString = display.text!
            titleString.remove(at: titleString.index(before: titleString.endIndex))
            display.text = titleString
            }
            print(display.text!)
        }
        
    }
    
   
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        print("\(digit) was called")
      
        
        
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            
            // ignore "." iff the digit is . and the display value contains . alreay
            display.text = (textCurrentlyInDisplay.contains(".") && (digit == ".")) ? textCurrentlyInDisplay : textCurrentlyInDisplay + digit
            
        } else {
        
            display.text = (digit == ".") ? "0." : digit
            if digit != "0" {
                userInTheMiddleOfTyping = true
            }
            
        }
    }
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
            
        }
        set{
            display.text = newValue.formatted
            
        }
    }
    
 
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        } else {
            displayValue = 0
        }
        
        if let description  = brain.description {
            descriptionDisplay.text = description + (brain.resultIsPending  ? " …" : " =")
            
        } else {
            descriptionDisplay.text = ""
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

