//
//  UIView+padding.swift
//  RennerMobile
//
//  Created by Fabricio Cordella on 30/05/20.
//  Copyright © 2020 CWI Software. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func padding(_ spacing: CGFloat = 0) -> Self {
        top(spacing)
        leading(spacing)
        trailing(-spacing)
        bottom(-spacing)
        return self
    }
    
    @discardableResult
    func paddingToSafeArea(_ spacing: CGFloat = 0) -> Self {
        top(layoutMarginsGuide.topAnchor, spacing)
        leading(layoutMarginsGuide.leadingAnchor, spacing)
        trailing(layoutMarginsGuide.trailingAnchor, -spacing)
        bottom(layoutMarginsGuide.bottomAnchor, -spacing)
        return self
    }
}
