//
//  UIViewExtensions.swift
//  GrubChaser
//
//  Created by Douglas Immig on 23/08/22.
//

import UIKit

public extension UIView {
    
    /// Much betterability
    var isVisible: Bool {
        get {
            return self.isHidden == false
        }
        set {
            self.isHidden = !newValue
        }
    }
    
    func fadeIn(_ duration: TimeInterval = 0.5,
                delay: TimeInterval = 0.0,
                alpha: CGFloat = 1.0,
                completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = alpha
        }, completion: completion)
    }
    
    func fadeInIfHidden() {
        if isHidden == false { return }
        fadeIn()
    }
    
    func fadeIn(_ duration: TimeInterval = 0.3) {
        self.isHidden = false
        self.alpha = 0
        
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }
    
    func fadeOut(_ duration: TimeInterval = 0.3) {
        UIView.animate(withDuration: duration,
                       animations: {
                            self.alpha = 0
                       },
                       completion: { _ in
                            self.isHidden = true
                       })
    }
    
    func fadeOut(_ duration: TimeInterval = 0.5,
                 delay: TimeInterval = 0.0,
                 completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: duration,
                       delay: delay,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: {
                            self.alpha = 0.0
                       },
                       completion: completion)
    }
    
    func animateAlpha(transitionTo alpha: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = alpha
        }
    }
    
    func rotate180Degrees(duration: CFTimeInterval = 1.0) {
        self.rotate(degrees: CGFloat(Double.pi))
    }
    
    func rotate(degrees: CGFloat, from: CGFloat = 0.0, duration: CFTimeInterval = 1.0) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = from
        rotateAnimation.toValue = degrees
        rotateAnimation.duration = duration
        
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
    
    //swiftlint:disable:next ibinspectable_in_extension
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    //swiftlint:disable:next ibinspectable_in_extension
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    //swiftlint:disable:next ibinspectable_in_extension
    @IBInspectable var borderColor: UIColor {
        get {
            guard let borderColor = layer.borderColor else { return .black }
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addShadow(offset: CGSize = CGSize(width: 0, height: 1), radius: CGFloat = 3, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = self.cornerRadius != 0 ? self.cornerRadius : radius
        self.layoutIfNeeded()
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func addDashedBorder(borderColor: UIColor) {
        
        let shapeLayer = CAShapeLayer()
        self.layoutIfNeeded()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [6, 4]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: frameSize.width / 2).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addGradientLayer(from startColor: UIColor = .black,
                          to endColor: UIColor = UIColor.black.withAlphaComponent(0.0)) {
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func getHeightConstraint() -> NSLayoutConstraint? {
        let heightConstraint = self.constraints.first { $0.firstAttribute == .height }
        
        return heightConstraint
    }
}
