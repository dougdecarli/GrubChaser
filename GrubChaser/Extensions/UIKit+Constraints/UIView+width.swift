//
//  UIView+width.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 30/05/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func width(_ constraint: NSLayoutDimension,
               _ constant: CGFloat = 0,
               priority: UILayoutPriority = .required,
               multiplier: CGFloat = 1) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(equalTo: constraint, multiplier: multiplier, constant: constant)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func widthWithMultiplier(_ constraint: NSLayoutDimension,
                             _ widthMultiplier: CGFloat = 1,
                             priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(equalTo: constraint, multiplier: widthMultiplier)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func widthGreaterThan(_ constraint: NSLayoutDimension,
                          _ constant: CGFloat,
                          priority: UILayoutPriority) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(greaterThanOrEqualTo: constraint, constant: constant)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func widthGreaterThan(_ constraint: NSLayoutDimension,
                          multiplier: CGFloat,
                          priority: UILayoutPriority) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(greaterThanOrEqualTo: constraint, multiplier: multiplier)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func widthGreaterThan(_ constant: CGFloat,
                          priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func widthLessThan(_ constraint: NSLayoutDimension,
                       _ constant: CGFloat,
                       priority: UILayoutPriority) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(lessThanOrEqualTo: constraint, constant: constant)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func widthLessThan(_ constraint: NSLayoutDimension,
                       multiplier: CGFloat,
                       priority: UILayoutPriority) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let widthConstraint = widthAnchor.constraint(lessThanOrEqualTo: constraint, multiplier: multiplier)
        widthConstraint.priority = priority
        widthConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func width(_ constant: CGFloat,
               priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        return self
    }
}
