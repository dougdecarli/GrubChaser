//
//  UIButton+Rx.swift
//  RNCommons
//
//  Created by Douglas Immig on 28/07/20.
//  Copyright © 2020 Lojas Renner. All rights reserved.
//

import RxSwift
import UIKit
import RxCocoa

extension Reactive where Base: UIButton {
    /// Reactive wrapper for `setTitleColor(_:for:)`
    public func titleColor(for controlState: UIControl.State = []) -> Binder<UIColor?> {
        return Binder(self.base) { button, color -> Void in
            button.setTitleColor(color, for: controlState)
        }
    }
}
