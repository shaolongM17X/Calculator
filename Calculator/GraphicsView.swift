//
//  GraphicsView.swift
//  Calculator
//
//  Created by Shaolong Lin on 7/12/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

@IBDesignable
class GraphicsView: UIView {

	private var axeDrawer = AxesDrawer(contentScaleFactor: 1)
	var controller: GraphicsViewController?
	
	@IBInspectable
	var pointsPerUnit: CGFloat = 30 {didSet {setNeedsDisplay()}}
	
	private var originPosition: CGPoint?
	@IBInspectable
	var origin: CGPoint {
		get {
			return originPosition ?? CGPoint(x: bounds.midX, y: bounds.midY)
		}
		set {
			setNeedsDisplay()
			originPosition = newValue
		}
	}
	
	func changeOrigin(recognizer: UITapGestureRecognizer) {
		recognizer.numberOfTapsRequired = 2
		if recognizer.state == .Ended {
			origin = recognizer.locationInView(self)
		}
	}
	
	func moveTheGraph(recognizer: UIPanGestureRecognizer) {
		var newOrigin = origin
		let dxdy = recognizer.translationInView(self)
		newOrigin.x += dxdy.x
		newOrigin.y += dxdy.y
		recognizer.setTranslation(CGPointZero, inView: self)
		origin = newOrigin
	}
	
	
	override func drawRect(rect: CGRect) {
        axeDrawer.drawAxesInRect(bounds, origin: origin, pointsPerUnit: pointsPerUnit)
		if controller != nil {
			if controller!.isReadyToPlot() {
				drawGraph()
			}
		}
    }
	
	private func drawGraph() {
		let path = UIBezierPath()
		for i in 0...Int(bounds.width) {
			let x = -origin.x / pointsPerUnit + CGFloat(i) / pointsPerUnit
			let y = controller!.getY(x)
			let currentPoint = getCoordinate(x, y: y)
			print(currentPoint)
			if i == 0 { // for the first point, we start the path
				path.moveToPoint(currentPoint)
			} else {
				path.addLineToPoint(currentPoint)
			}
		}
		path.stroke()
	}

	private func getCoordinate(x: CGFloat, y: Double) -> CGPoint {
		return CGPoint(x: x * pointsPerUnit + origin.x, y: -(CGFloat(y) * pointsPerUnit) + origin.y)
	}

}
