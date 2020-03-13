//
//  AttributedString-Extensions.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

import Foundation

#if canImport(UIKit)
import UIKit
typealias Font  = UIFont
typealias Color = UIColor
#elseif canImport(AppKit)
import AppKit
typealias Font  = NSFont
typealias Color = NSColor
#endif

extension String {

    func regular(size: CGFloat = Font.systemFontSize) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.font: Font.systemFont(ofSize: size)])
    }

    func medium(size: CGFloat = Font.systemFontSize) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.font: Font.systemFont(ofSize: size, weight: .medium)])
    }

    func bold(size: CGFloat = Font.systemFontSize) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.font: Font.systemFont(ofSize: size, weight: .bold)])
    }

    var attributed: NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

}

extension NSAttributedString {
    /// Returns a colored attributed string
    func colored(color: Color) -> NSMutableAttributedString {
        let string = NSMutableAttributedString(attributedString: self)
        string.addAttributes([.foregroundColor: color], range: NSRange(location: 0, length: length))
        return string
    }
}

//MARK: - Operator support for attributed strings
infix operator +  : AdditionPrecedence
infix operator +-+ : AdditionPrecedence

public func + (left: NSAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
    let string = NSMutableAttributedString(attributedString: left)
    string.append(right)
    return string
}

public func + (left: String, right: NSAttributedString) -> NSMutableAttributedString {
    return left.attributed + right
}

public func + (left: NSAttributedString, right: String) -> NSMutableAttributedString {
    return left + right.attributed
}

public func + (left: NSMutableAttributedString, right: String) -> NSMutableAttributedString {
    return NSAttributedString(attributedString: left) + right.attributed
}

public func +-+ (left: NSAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
    return left + " " + right
}
