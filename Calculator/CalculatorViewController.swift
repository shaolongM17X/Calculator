//
//  ViewController.swift
//  Calculator
//
//  Created by Shaolong Lin on 7/5/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {

	@IBOutlet private weak var display: UILabel!
	private var userIsInTheMiddleOfTyping = false
	private var userIsInTheMiddleOfTypingFloatingNumber = false
	
	
	@IBOutlet weak var processDescription: UILabel!
	
	// send the program from CalculatorBrain to GraphicsViewController
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if !userIsInTheMiddleOfTyping {
			var destinationvc = segue.destinationViewController
			if let navcon = destinationvc as? UINavigationController {
				destinationvc = navcon.visibleViewController ?? destinationvc
			}
			if let graphicsvc = destinationvc as? GraphicsViewController {
				graphicsvc.brain = brain
				graphicsvc.currentVariable = "M"
				graphicsvc.navigationItem.title = brain.processDescription
				
			}
		}
	}
	
	
	//	when user pressed digits
	@IBAction func onDigitClicked(sender: UIButton) {
		let digit = sender.currentTitle!
		if userIsInTheMiddleOfTyping {
			display.text = display.text! + digit
		} else {
			display.text = digit
		}
		userIsInTheMiddleOfTyping = true
    }
	

//	When user pressed . in the screen
	@IBAction func pointSelected(sender: UIButton) {
		if !userIsInTheMiddleOfTypingFloatingNumber {
			display.text! += "."
			userIsInTheMiddleOfTypingFloatingNumber = true
			userIsInTheMiddleOfTyping = true
		}
	}

	
//	When the user pressed AC in the screen, we clear the view
	@IBAction func clearTheView(sender: UIButton) {
		userIsInTheMiddleOfTyping = false
		userIsInTheMiddleOfTypingFloatingNumber = false
		display.text = String(0)
		processDescription.text = " "
		brain.clearEveryThing()
	}
	
//	when user pressed action buttons like +, -, ...
	private var brain = CalculatorBrain()
	private var displayValue: Double {
		get {
			return Double(display.text!)!
		}
		set {
			display.text = String(newValue)
		}
	}
	@IBAction func performOperation(sender: UIButton) {
		if userIsInTheMiddleOfTyping {
			brain.setOperand(displayValue)
			userIsInTheMiddleOfTyping = false
			userIsInTheMiddleOfTypingFloatingNumber = false
		}
		if let mathematicalSymbol = sender.currentTitle {
			brain.performOperation(mathematicalSymbol)
		}
		displayValue = brain.result
		processDescription.text = brain.processDescription
		if brain.isPartialResult {
			processDescription.text! += "..."
		} else {
			processDescription.text! += " = "
		}
	}

	@IBAction func onDeleteClicked(sender: UIButton) {
		if userIsInTheMiddleOfTyping {
			var displayText = display.text!
			let charCount = displayText.characters.count
			if charCount == 1 {
				display.text = String(0)
				userIsInTheMiddleOfTyping = false
			} else if displayText.characters.last == "." {
				displayText.removeAtIndex(displayText.endIndex.predecessor())
				display.text = displayText
				userIsInTheMiddleOfTypingFloatingNumber = false
			} else {
				displayText.removeAtIndex(displayText.endIndex.predecessor())
				display.text = displayText
			}
		} else { // we undo last thing we did
			brain.forgetLastThing()
			displayValue = brain.result
			processDescription.text = brain.processDescription
		}
	}
	
	// set value of variable M to current value in display
	@IBAction func setM() {
		// This part is important because when we set M, we are actually typing digits, and as a result these two booleans will become true!!!
		userIsInTheMiddleOfTyping = false
		userIsInTheMiddleOfTypingFloatingNumber = false
		//////////////////////
		
		brain.variableValues["M"] = displayValue
		displayValue = brain.result
		processDescription.text = brain.processDescription
		
	}
	// put M as an operand
	@IBAction func setOperandM() {
		brain.setOperand("M")
	}
	
}

