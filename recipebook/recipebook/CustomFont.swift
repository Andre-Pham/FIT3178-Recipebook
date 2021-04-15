//
//  CustomFont.swift
//  recipebook
//
//  Created by Andre Pham on 15/4/21.
//

import UIKit

class CustomFont: UIFont {
    
    // MARK: - Properties
    
    // Default sizes and weights for subtitle
    static let SUBTITLE_SIZE = 20.0
    static let SUBTITLE_STYLE: TextStyle = .body
    static let SUBTITLE_WEIGHT: Weight = .bold
    
    // Default sizes and weights for body
    static let BODY_SIZE = 17.0
    static let BODY_STYLE: TextStyle = .body
    static let BODY_WEIGHT: Weight = .regular
    
    // MARK: - Methods

    // SOURCE: https://mackarous.com/dev/2018/12/4/dynamic-type-at-any-font-weight#font-weight
    // AUTHOR: Andrew Mackarous - https://mackarous.com
    /// Assigns a font to a text field
    static func setFont(size: Double, style: TextStyle, weight: Weight) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let font = UIFont.systemFont(ofSize: CGFloat(size), weight: weight)
        return metrics.scaledFont(for: font)
    }
    
    /// Assigns a font to a text field with the parameters to make a subtitle font
    static func setSubtitleFont() -> UIFont {
        return self.setFont(size: self.SUBTITLE_SIZE, style: self.SUBTITLE_STYLE, weight: self.SUBTITLE_WEIGHT)
    }
    
    /// Assigns a font to a text field with the parameters to make a body font
    static func setBodyFont() -> UIFont {
        return self.setFont(size: self.BODY_SIZE, style: self.BODY_STYLE, weight: self.BODY_WEIGHT)
    }
    
}
