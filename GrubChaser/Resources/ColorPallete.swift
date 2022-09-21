//
//  ColorPallete.swift
//  GrubChaser
//
//  Created by Douglas Immig on 23/08/22.
//

import UIKit

class ColorPallete {
    static var defaultRed = UIColor(hexString: "#EE6A53")
    static var defaultYellow = UIColor(hexString: "#FFD60A")
    
    static var commonBlack = UIColor(hexString: "#1E1E1F")
    static var commonLightGray = UIColor(hexString: "#E0E0E0")
    static var commonWhite = UIColor(hexString: "#F2F2F2")
    static var commonDarkGray = UIColor(hexString: "#706F6F")
    static var commonMiddleGray = UIColor(hexString: "#ACACAC")
    
}

public extension UIColor {
    
    static var oldPriceGray: UIColor {
        return .init(hexString: "#333333")
    }

    static var sixtyPercentAlphaWhite: UIColor {
        return UIColor(white: 1, alpha: 0.6)
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        
        //swiftlint:disable:next identifier_name
        let a, r, g, b: UInt32
        
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
