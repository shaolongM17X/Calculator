//
//  GraphicsViewController.swift
//  Calculator
//
//  Created by Shaolong Lin on 7/12/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class GraphicsViewController: UIViewController {
    
	var brain: CalculatorBrain?
	var currentVariable: String?

	@IBOutlet weak var graphicsView: GraphicsView! {
		didSet {
			graphicsView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(GraphicsViewController.changeScale(_:))))
			graphicsView.addGestureRecognizer(UITapGestureRecognizer(target: graphicsView, action: #selector(GraphicsView.changeOrigin(_:))))
			graphicsView.addGestureRecognizer(UIPanGestureRecognizer(target: graphicsView, action: #selector(GraphicsView.moveTheGraph(_:))))
			graphicsView.controller = self
		}
	}
	
	
	// used to change the scale of our graphics view, called by UIPinchGestureRecognizer
	func changeScale(recognizer: UIPinchGestureRecognizer) {
		switch recognizer.state {
		case .Changed, .Ended:
			graphicsView.pointsPerUnit *= recognizer.scale
			recognizer.scale = 1.0
		default:
			break
		}
	}
	
	func isReadyToPlot() -> Bool {
		return self.brain != nil
	}
	
	func getY(x: CGFloat) -> Double {
		brain!.variableValues[currentVariable!] = Double(x)
		return brain!.result
	}
	
	

}
