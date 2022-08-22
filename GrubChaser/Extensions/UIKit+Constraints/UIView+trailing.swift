//
//  UIView+trailing.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 29/05/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func trailing(_ constraint: NSLayoutXAxisAnchor,
                  _ spacing: CGFloat = 0,
                  priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = trailingAnchor.constraint(equalTo: constraint, constant: spacing)
        leadingConstraint.priority = priority
        leadingConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func trailing(_ spacing: CGFloat = 0,
                  priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        guard let constraint = superview?.trailingAnchor else { return self }
        trailing(constraint, spacing, priority: priority)
        return self
    }
    
    @discardableResult
    func trailingGreaterThen(_ constraint: NSLayoutXAxisAnchor,
                             _ spacing: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = trailingAnchor.constraint(greaterThanOrEqualTo: constraint, constant: spacing)
        trailingConstraint.priority = priority
        trailingConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func trailingGreaterThen(_ spacing: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        guard let constraint = superview?.trailingAnchor else { return self }
        trailingGreaterThen(constraint, spacing, priority: priority)
        return self
    }
    
    @discardableResult
    func trailingLessThan(_ constraint: NSLayoutXAxisAnchor,
                          _ spacing: CGFloat = 0,
                          priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = trailingAnchor.constraint(lessThanOrEqualTo: constraint, constant: spacing)
        trailingConstraint.priority = priority
        trailingConstraint.isActive = true
        return self
    }
    
    @discardableResult
    func trailingLessThan(_ spacing: CGFloat = 0,
                          priority: UILayoutPriority = .required) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        guard let constraint = superview?.trailingAnchor else { return self }
        trailingLessThan(constraint, spacing, priority: priority)
        return self
    }
}
