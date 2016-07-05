//
//  ViewController.swift
//  Calculator
//
//  Created by Shaolong Lin on 7/5/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet private weak var display: UILabel!
	private var displayValue: Double {
		get {
			return Double(display.text!)!
		}
		set {
			display.text = String(newValue)
		}
	}
	
	
	private var userIsInTheMiddleOfTyping = false
	private var userIsInTheMiddleOfTypingFloatingNumber = false
	
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
	}
}

