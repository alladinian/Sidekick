//
//  Labels.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

#if canImport(UIKit)
import UIKit

public extension UILabel {
    convenience init(_ text: String) {
        self.init(frame: .zero)
        self.text = text
    }
}


public class PaddedLabel: UILabel {
    public var padding: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}
#endif
