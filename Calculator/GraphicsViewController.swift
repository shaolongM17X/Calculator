//
//  GraphicsViewController.swift
//  Calculator
//
//  Created by Shaolong Lin on 7/12/16.
//  Copyright © 2016 Shaolong Lin. All rights reserved.
//

import UIKit

class GraphicsViewController: UIViewController {
    


	@IBOutlet weak var graphicsView: GraphicsView! {
		didSet {
			graphicsView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphicsView, action: #selector(GraphicsView.changeScale(_:))))
		}
	}
	

}
