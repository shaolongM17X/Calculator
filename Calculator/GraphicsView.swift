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
	
	@IBInspectable
	var pointsPerUnit: CGFloat = 30 {didSet {setNeedsDisplay()}}
	
	override func drawRect(rect: CGRect) {
        axeDrawer.drawAxesInRect(bounds, origin: CGPoint(x: bounds.midX, y: bounds.midY), pointsPerUnit: pointsPerUnit)
    }
	
	func changeScale(recognizor: UIPinchGestureRecognizer) {
		switch recognizor.state {
		case .Changed, .Ended:
			pointsPerUnit *= recognizor.scale
			recognizor.scale = 1.0
		default:
			break
		}
	}


}
