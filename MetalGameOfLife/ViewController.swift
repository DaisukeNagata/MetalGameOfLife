//
//  ViewController.swift
//  MetalGameOfLife
//
//  Created by nagatadaisuke on 2017/09/17.
//  Copyright © 2017年 nagatadaisuke. All rights reserved.
//

import UIKit
import MetalKit

class ViewController: UIViewController {
    
    @IBOutlet var metalView: MTKView!
    var aAPLRenderer = AAPLRenderer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.aAPLRenderer.screenAnimation = 11
        
        self.setupView()
        
        self.metalView.isUserInteractionEnabled = true
        
        self.becomeFirstResponder()
        
        self.swipeMethod()
    }
    
    private func setupView()
    {
        self.metalView.device = MTLCreateSystemDefaultDevice()
        self.metalView.colorPixelFormat = MTLPixelFormat.bgra8Unorm
        self.metalView.clearColor =  MTLClearColorMake(0, 0, 0, 1)
        self.metalView.drawableSize = self.metalView.bounds.size
        
        // Create renderer and make it the delegate of our MTKView
        self.aAPLRenderer = self.aAPLRenderer.instanceWithView(view: self.metalView)
    }
    
    private func swipeMethod()
    {
        let directions: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self,
                                   action:#selector(handleSwipe(sender:)))
            
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    func locationInGridForLocationInView(point:CGPoint)->CGPoint
    {
        let viewSize = self.view.frame.size
        let normalizedWidth = point.x / viewSize.width
        let normalizedHeight = point.y / viewSize.height
        
        let gridX = round(normalizedWidth * CGFloat(self.aAPLRenderer.gridSize.width))
        let gridY = round(normalizedHeight * CGFloat(self.aAPLRenderer.gridSize.height))
        
        return CGPoint(x:gridX,y:gridY)
    }
    
    func activateRandomCellsForPoint(point:CGPoint)
    {
        let gridLocation =  self.locationInGridForLocationInView(point: point)
        self.aAPLRenderer.activateRandomCellsInNeighborhoodOfCell(cell: gridLocation)
    }
    
    @objc func handleSwipe(sender: UISwipeGestureRecognizer)
    {
        _ = self.aAPLRenderer.instanceWithView(view: self.metalView)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        
        for touch : UITouch in touches {
            let location = touch.location(in: self.view)
            self.activateRandomCellsForPoint(point: location)
        }
    }
}
