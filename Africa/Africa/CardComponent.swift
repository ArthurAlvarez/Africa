//
//  CardComponent.swift
//  Africa
//
//  Created by Arthur Alvarez on 7/7/15.
//  Copyright (c) 2015 Arthur Alvarez. All rights reserved.
//

import UIKit

/**
    Delegate protocol for CardComponent
*/
protocol CardComponentDelegate:class{
    func CardDidChangeState(cardComponent : CardComponent, open : Bool)
}

@IBDesignable class CardComponent: UIView {

    // Card size
    @IBInspectable var cardSize_x : Double = 30.0
    @IBInspectable var cardSize_y : Double = 15.0
    
    // Card parts
    var squareView : UIView!
    var bottomView : UIView!
    
    // Animation Parameters
    var turn : Bool = false
    let eyePosition = CGFloat(800.0)
    
    // Shadow Layer
    var subLayer = CALayer()
	
	// Flag to know if is closed or not
	var isOpened : Bool = true
    
    // Delegate
    weak var delegate : CardComponentDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        self.setupView()
    }

    func setupView(){
        
        //Sets the card views and layers
        self.squareView = UIView(frame: CGRect(x: 0.0, y: cardSize_y*0.5, width: cardSize_x, height: cardSize_y))
        self.squareView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)

        self.bottomView = UIView(frame: CGRect(x: 0.0, y: cardSize_y, width: cardSize_x, height: cardSize_y))
        
        self.bottomView.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        self.subLayer.backgroundColor = UIColor.grayColor().CGColor
        
        self.subLayer.frame =  CGRectMake(0, 0, self.bottomView.frame.size.width, self.bottomView.frame.size.height)
        
        self.subLayer.opacity = 0.0
        
        self.bottomView.layer.addSublayer(self.subLayer)

        self.addSubview(bottomView)
        self.addSubview(squareView)
        
        self.squareView.layer.anchorPoint = CGPointMake(0.5, 1.0)
    }
    
    func setupConstraints()
    {
        self.squareView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bottomView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let views = ["bv": self.bottomView, "sv": self.squareView]
        
        let yConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[sv]-[bv]-| ", options: .DirectionLeadingToTrailing, metrics: nil, views: views)
        let svXConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[sv]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: views)
        let bvXConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[bv]-|", options: .DirectionLeadingToTrailing, metrics: nil, views: views)
        
        self.addConstraints(yConstraints)
        self.addConstraints(svXConstraints)
        self.addConstraints(bvXConstraints)
    }
    
    func animate() {
        
        //Make rotation over all transformations already done
        var rotationAndPerspectiveTransform = self.squareView.layer.transform
        var shadow : Float
        //Create the perspective effect. The m34 parameter changes the distance from
        //the layer to the projection plane.
        //Reference: https://en.wikipedia.org/wiki/3D_projection#Perspective_projection
        rotationAndPerspectiveTransform.m34 = -1.0 / eyePosition
        
        if (!turn) {
            
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(M_PI * 1.0), CGFloat(-1.0), CGFloat(0.0), CGFloat(0.0));
            shadow = 1.0
        } else {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(M_PI * 0), CGFloat(-1.0), CGFloat(0.0), CGFloat(0.0));
            shadow = 0
        }
        
        rotateTopImage(rotationAndPerspectiveTransform, shadow: shadow, duration: 1.0)
        
        turn = !turn
		
		isOpened = !isOpened
		
        delegate?.CardDidChangeState(self, open: turn)
    }
    
    
    //MARK: Auxiliary Methods
    
    func rotateTopImage(transform:CATransform3D, shadow: Float, duration:Float) {
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        
        animation.duration = CFTimeInterval(duration)
        animation.toValue = NSValue(CATransform3D: transform)
        
        let animationShadow = CABasicAnimation(keyPath: "opacity")
        animationShadow.fillMode = kCAFillModeForwards
        animationShadow.removedOnCompletion = false
        animationShadow.duration = CFTimeInterval(duration)
        animationShadow.toValue = shadow
        
        self.squareView.layer.addAnimation(animation, forKey: nil)
        self.subLayer.addAnimation(animationShadow, forKey: nil)
    }

}
