//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Shaolong Lin on 7/5/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import Foundation

class CalculatorBrain
{
	private var accumulator = 0.0
	
	func setOperand(operand: Double) {
		accumulator = operand
		
	}
	
	func performOperation(symbol: String) {
		
	}
	
	var result: Double {
		get {
			return accumulator
		}
	}
	
}