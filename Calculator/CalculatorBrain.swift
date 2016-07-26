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
	private var descriptionAccumulator = "0"
	private var currentPrecedence = Int.max
	private var internalProgram = [AnyObject]()
	
	// used to store all the variables and their corresponding values
	// when the values changed, we will restore the program to recalculate result
	var variableValues = [String: Double]() {
		didSet {
			program = internalProgram
		}
	}
	
	var result: Double {
		get {
			return accumulator
		}
	}
	
	// the description showing all the processes that led to this result
	var processDescription: String {
		get {
			if pending != nil {
				return pending!.descriptionFunction(pending!.savedDescriptionAccumulator, pending!.savedDescriptionAccumulator == descriptionAccumulator ? "" : descriptionAccumulator)
			} else {
				return descriptionAccumulator
			}
		}
	}
	
	typealias PropertyList = AnyObject
	var isPartialResult: Bool {
		get {
			return pending != nil
		}
	}
	
	func setOperand(operand: Double) {
		accumulator = operand
		descriptionAccumulator = String(operand)
		internalProgram.append(operand)
	}
	
	// variable related
	func setOperand(variableName: String) {
		accumulator = variableValues[variableName] ?? 0.0
		descriptionAccumulator = variableName
		internalProgram.append(variableName)
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
		"sin": Operation.UnaryOperation(sin, { "sin(\($0))" }),
		"cos": Operation.UnaryOperation(cos, { "cos(\($0))" }),
		"tan": Operation.UnaryOperation(tan, { "tan(\($0))" }),
		"ln": Operation.UnaryOperation(log, { "ln(\($0))" }),
		"x³": Operation.UnaryOperation({pow($0, 3)}, { "(\($0))³" }),
		"x²": Operation.UnaryOperation({pow($0, 2)}, { "(\($0))²" }),
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
			internalProgram.append(symbol)
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
	
	
	
	
	func clear() {
		accumulator = 0.0
		pending = nil
		descriptionAccumulator = "0"
		currentPrecedence = Int.max
		internalProgram.removeAll()
		
	}
	
	func clearEveryThing() {
		clear()
		variableValues.removeAll()
	}
	
	
	var program: PropertyList {
		get {
			return internalProgram
		}
		set {
			clear()
			if let arrayOfOps = newValue as? [AnyObject] {
				for op in arrayOfOps {
					if let operand = op as? Double {
						setOperand(operand)
					} else if let operation = op as? String {
						// two cases: 1. operation symbol 2. variable
						if variableValues[operation] != nil {
							setOperand(operation)
						} else {
							performOperation(operation)
						}
					}
				}
			}
		}
	}
	
	func forgetLastThing() {
		if !internalProgram.isEmpty {
			internalProgram.removeLast()
			program = internalProgram
		}
	}
}