//
//  UIView+height.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 30/05/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func height(_ constraint: NSLayoutDimension,
                _ constant: CGFloat = 0,
                priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalTo: constraint, constant: constant)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightWithMultiplier(_ constraint: NSLayoutDimension,
                              _ heightMultiplier: CGFloat = 1,
                              priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalTo: constraint, multiplier: heightMultiplier)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightGreaterThan(_ constraint: NSLayoutDimension,
                          _ constant: CGFloat,
                          priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualTo: constraint, constant: constant)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightGreaterThan(_ constraint: NSLayoutDimension,
                          multiplier: CGFloat = 1,
                          priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualTo: constraint, multiplier: multiplier)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightGreaterThan(_ const: CGFloat,
                          priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: const)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightLessThan(_ constraint: NSLayoutDimension,
                        _ constant: CGFloat,
                        priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(lessThanOrEqualTo: constraint, constant: constant)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightLessThan(_ constraint: NSLayoutDimension,
                        multiplier: CGFloat,
                        priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(lessThanOrEqualTo: constraint, multiplier: multiplier)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func heightLessThan(_ const: CGFloat,
                        priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(lessThanOrEqualToConstant: const)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }

    @discardableResult
    func height(_ constant: CGFloat,
                priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = heightAnchor.constraint(equalToConstant: constant)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ constraint: NSLayoutDimension,
                _ constant: CGFloat,
                multiple: CGFloat,
                priority: UILayoutPriority = .required) -> Self {
        let heightConstraint = heightAnchor.constraint(equalTo: constraint, multiplier: multiple, constant: constant)
        heightConstraint.priority = priority
        heightConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func height(_ constant: CGFloat = 0,
                multiple: CGFloat,
                priority: UILayoutPriority = .required) -> Self {
        guard let constraint = superview?.heightAnchor else { return self }
        return height(constraint, constant, multiple: multiple, priority: priority)
    }
}
