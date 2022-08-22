//
//  UIView+top.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 29/05/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func top(_ constraint: NSLayoutYAxisAnchor,
             _ spacing: CGFloat = 0,
             priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = topAnchor.constraint(equalTo: constraint, constant: spacing)
        topConstraint.priority = priority
        topConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func top(_ spacing: CGFloat = 0,
             priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        guard let constraint = superview?.topAnchor else { return self }
        top(constraint, spacing, priority: priority)
        return self
    }
    
    @discardableResult
    func topGreaterThan(_ constraint: NSLayoutYAxisAnchor,
                        _ spacing: CGFloat = 0,
                        priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = topAnchor.constraint(greaterThanOrEqualTo: constraint, constant: spacing)
        topConstraint.priority = priority
        topConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func topGreaterThan(_ spacing: CGFloat = 0,
                        priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        guard let constraint = superview?.topAnchor else { return self }
        topGreaterThan(constraint, spacing, priority: priority)
        return self
    }
    
    @discardableResult
    func topLessThan(_ constraint: NSLayoutYAxisAnchor,
                     _ spacing: CGFloat = 0,
                     priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = topAnchor.constraint(lessThanOrEqualTo: constraint, constant: spacing)
        topConstraint.priority = priority
        topConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func topLessThan(_ spacing: CGFloat = 0,
                     priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        guard let constraint = superview?.topAnchor else { return self }
        topLessThan(constraint, spacing, priority: priority)
        return self
    }
}
