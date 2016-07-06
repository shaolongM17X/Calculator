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
	private var description = ""
	private var displayNumberInEqual = true
	var isPartialResult: Bool {
		get {
			return pending != nil
		}
	}
	
	func setOperand(operand: Double) {
		accumulator = operand
		if pending == nil {
			description = String(operand)
			displayNumberInEqual = true
		}
	}
	
	private enum Operation {
		case Constant(Double)
		case UnaryOperation((Double) -> Double)
		case BinaryOperation((Double, Double) -> Double)
		case Equals
	}
	private var operations: Dictionary<String, Operation> = [
		"π": Operation.Constant(M_PI),
		"e": Operation.Constant(M_E),
		"√": Operation.UnaryOperation(sqrt),
		"cos": Operation.UnaryOperation(cos),
		"×": Operation.BinaryOperation({$0 * $1}),
		"+": Operation.BinaryOperation({$0 + $1}),
		"−": Operation.BinaryOperation({$0 - $1}),
		"÷": Operation.BinaryOperation({$0 / $1}),
		"=": Operation.Equals
	]
	
	struct PendingBinaryOperation {
		var binaryOperation: (Double, Double) -> Double
		var firstOperand: Double
	}
	
	private var pending: PendingBinaryOperation?
	
	private func executePendingBinaryOperation() {
		if pending != nil {
			accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
			pending = nil
		}
	}
	
	func performOperation(symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .Constant(let value):
				accumulator = value
				description += symbol
				displayNumberInEqual = false
			case .UnaryOperation(let function):
				if pending == nil { // when there's no pending operation, we can simply wrap everything with that unary operation
					description = "\(symbol)(\(description))"
				} else { // when there is pending operation, we wrap this unary operation first since it has higher priority
					description += "\(symbol)(\(accumulator))"
				}
				displayNumberInEqual = false
				accumulator = function(accumulator)
			case .BinaryOperation(let function):
				if pending == nil {
					description += " \(symbol) "
				} else { // we record current value in accumulator first
					description = "(\(description)\(accumulator)) \(symbol) "
				}
				executePendingBinaryOperation()
				pending = PendingBinaryOperation(binaryOperation: function, firstOperand: accumulator)
			case .Equals:
				if pending != nil && displayNumberInEqual { // when we just finished typing constant or doing unary operation, there's no pending operation, and if we click equal now, we don't want to record current value in accumulator
					description += "\(accumulator)"
				}
				executePendingBinaryOperation()
				displayNumberInEqual = true
			}
		}
	}
	
	var result: Double {
		get {
			return accumulator
		}
	}
	
	var processDescription: String {
		get {
			return description
		}
	}
	
	func clearEveryThing() {
		accumulator = 0.0
		pending = nil
		displayNumberInEqual = true
		description = ""
	}
	
}