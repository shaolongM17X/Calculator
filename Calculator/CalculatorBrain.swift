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
	private var descriptionAccumulator = " "
	private var currentPrecedence = Int.max
	var isPartialResult: Bool {
		get {
			return pending != nil
		}
	}
	
	func setOperand(operand: Double) {
		accumulator = operand
		descriptionAccumulator = String(operand)
	}
	
	private enum Operation {
		case Constant(Double)
		case UnaryOperation((Double) -> Double, (String) -> String)
		case BinaryOperation((Double, Double) -> Double, (String, String) -> (String), Int)
		case Equals
	}
	private var operations: Dictionary<String, Operation> = [
		"π": Operation.Constant(M_PI),
		"e": Operation.Constant(M_E),
		"√": Operation.UnaryOperation(sqrt, { "√(\($0))" }),
		"cos": Operation.UnaryOperation(cos, { "cos(\($0))" }),
		"×": Operation.BinaryOperation({$0 * $1}, { "\($0) × \($1)" }, 1),
		"+": Operation.BinaryOperation({$0 + $1}, { "\($0) + \($1)" }, 0),
		"−": Operation.BinaryOperation({$0 - $1}, { "\($0) - \($1)" }, 0),
		"÷": Operation.BinaryOperation({$0 / $1}, { "\($0) ÷ \($1)" }, 1),
		"=": Operation.Equals
	]
	
	struct PendingBinaryOperation {
		var binaryOperation: (Double, Double) -> Double
		var firstOperand: Double
		var descriptionFunction: (String, String) -> String
		var savedDescriptionAccumulator: String
	}
	
	private var pending: PendingBinaryOperation?
	
	private func executePendingBinaryOperation() {
		if pending != nil {
			descriptionAccumulator = pending!.descriptionFunction(pending!.savedDescriptionAccumulator, descriptionAccumulator)
			accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
			pending = nil
		}
	}
	
	func performOperation(symbol: String) {
		if let operation = operations[symbol] {
			switch operation {
			case .Constant(let value):
				accumulator = value
				descriptionAccumulator = symbol
			case .UnaryOperation(let valueFunction, let descriptionFunc):
				accumulator = valueFunction(accumulator)
				descriptionAccumulator = descriptionFunc(descriptionAccumulator)
			case .BinaryOperation(let valueFunction, let descriptionFunc, let precedence):
				executePendingBinaryOperation()
				if currentPrecedence < precedence {
					descriptionAccumulator = "(\(descriptionAccumulator))"
				}
				currentPrecedence = precedence
				pending = PendingBinaryOperation(binaryOperation: valueFunction, firstOperand: accumulator, descriptionFunction: descriptionFunc, savedDescriptionAccumulator: descriptionAccumulator)
			case .Equals:
				executePendingBinaryOperation()
	
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
			if pending != nil {
				return pending!.descriptionFunction(pending!.savedDescriptionAccumulator, pending!.savedDescriptionAccumulator == descriptionAccumulator ? "" : descriptionAccumulator)
			} else {
				return descriptionAccumulator
			}
		}
	}
	
	
	func clearEveryThing() {
		accumulator = 0.0
		pending = nil
		descriptionAccumulator = " "
		currentPrecedence = Int.max
	}
	
}