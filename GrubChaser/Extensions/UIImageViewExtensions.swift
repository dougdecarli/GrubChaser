//
//  UIImageViewExtensions.swift
//  GrubChaser
//
//  Created by Douglas Immig on 03/09/22.
//

import UIKit
import Nuke

extension UIImageView {
    func loadImage(imageURL: String,
                   genericImage: UIImage) {
        guard let url = URL(string: imageURL) else { return }
        let options = ImageLoadingOptions(placeholder: genericImage,
                                          contentModes: .init(success: .scaleAspectFill,
                                                              failure: .center,
                                                              placeholder: .scaleAspectFill))
        
        Nuke.loadImage(with: url,
                       options: options,
                       into: self)
    }
}
