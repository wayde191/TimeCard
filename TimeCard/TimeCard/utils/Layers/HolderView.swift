//
//  HolderView.swift
//  SBLoader
//
//  Created by Satraj Bambra on 2015-03-17.
//  Copyright (c) 2015 Satraj Bambra. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
  func animateLabel()
}

class HolderView: UIView {

  var ovalLayer = OvalLayer()
  let triangleLayer = TriangleLayer()
  let redRectangleLayer = RectangleLayer()
  let blueRectangleLayer = RectangleLayer()
  let arcLayer = ArcLayer()

  var parentFrame :CGRect = CGRectZero
  weak var delegate:HolderViewDelegate?
    
    var ovalTimer: NSTimer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = Colors.clear
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  func addOval() {
    layer.addSublayer(ovalLayer)
    ovalLayer.expand()
    NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "wobbleOval",
      userInfo: nil, repeats: false)
  }
    
    func stopOval() {
        ovalTimer!.invalidate()
    }

    func wobbleOval() {
        ovalTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: ovalLayer, selector: "wobble", userInfo: nil, repeats: true)
    }
    
    func drawBlueAnimatedRectangle() {
        ovalLayer.removeFromSuperlayer()
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.animateStrokeWithColor(Colors.blue)
        NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: "drawArc",
            userInfo: nil, repeats: false)
    }

    func drawArc() {
        layer.addSublayer(arcLayer)
        arcLayer.animate()
        NSTimer.scheduledTimerWithTimeInterval(1.30, target: self, selector: "expandView",
          userInfo: nil, repeats: false)
    }

    func expandView() {
        layer.sublayers = nil
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
          self.frame = self.parentFrame
          }, completion: { finished in
            self.addLabel()
        })
    }

    func addLabel() {
        delegate?.animateLabel()
    }

}
