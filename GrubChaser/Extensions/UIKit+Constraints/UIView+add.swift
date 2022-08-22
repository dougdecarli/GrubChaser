//
//  UIView+add.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 30/05/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func add(_ view: UIView) -> Self {
        addSubview(view)
        return self
    }
    
    @discardableResult
    func add(_ views: [UIView]) -> Self {
        views.forEach(addSubview)
        return self
    }
    
    @discardableResult
    func add(_ views: UIView...) -> Self {
        views.forEach(addSubview)
        return self
    }
}

public extension UIView {
    @discardableResult
    func addConstraint(_ constraint: NSLayoutConstraint,
                       _ priority: UILayoutPriority = .required) -> Self {
        constraint.priority = priority
        constraint.isActive = true
        return self
    }
}

public extension UIStackView {
    @discardableResult
    func addArranged(_ view: UIView) -> Self{
        addArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func addArranged(_ views: [UIView]) -> Self {
        views.forEach(addArrangedSubview)
        return self
    }
}
