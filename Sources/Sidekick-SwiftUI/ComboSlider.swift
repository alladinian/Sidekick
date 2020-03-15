//
//  ComboSlider.swift
//  Elements
//
//  Created by Vasilis Akoinoglou on 16/11/19.
//  Copyright © 2019 Vasilis Akoinoglou. All rights reserved.
//

import Foundation
import Sidekick
import SwiftUI

//class ElementMeasurementFormatter: MeasurementFormatter {
//    override func attributedString(for obj: Any, withDefaultAttributes attrs: [NSAttributedString.Key : Any]? = nil) -> NSAttributedString? {
//        <#code#>
//    }
//}

struct Formatters {
    static let generic: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 3
        f.minimumFractionDigits = 3
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    static let angle: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.positiveSuffix = " °"
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 0
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    static let measurement: MeasurementFormatter = {
        let f = MeasurementFormatter()
        //f.unitStyle   = .short
        f.unitOptions = [.providedUnit]//, .naturalScale]
        return f
    }()

}

public struct ComboSlider: View {

    public var inactiveColor: NSColor     = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.2470588235)
    public var name: String               = ""
    public var range                      = 0.0...1.0

    var undoManager: UndoManager? = nil

    public init(name: String, value: Binding<CGFloat>) {
        self.name = name
        self._value = value
    }

    @Binding public var value: CGFloat {
        willSet {
            // Undo registration?
//            let (old, new) = (self.value, newValue)
//
//            // any changes to the model will be registered with the undo manager
//            guard let um = self.undoManager, um.isUndoRegistrationEnabled else { return }
//            um.registerUndo(withTarget: self) { (target: ComboSlider) -> Void in
//                withAnimation(Animation.spring(blendDuration: 2.5)) {
//                    target.value = old
//                }
//            }
        }
    }

    var unit: Unit? = nil

    @State private var isActive = true
    @State private var isEditing = false

    func mappedValue(_ value: Double) -> CGFloat {
        CGFloat(map(value: value, from: range, to: 0.0...1.0))
    }

    func inversedMappedValue(_ value: Double) -> CGFloat {
        CGFloat(map(value: value, from:  0.0...1.0, to: range))
    }

    private func sliderGesture(forWidth width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 1).onChanged { value in
            let perc = min(max(0, Double(value.location.x / width * 100.0)), 100.0)
            self.value = self.inversedMappedValue(perc / 100.0)
        }
    }

    var formattedValue: String {
        guard let unit = unit else { return Formatters.generic.string(for: value) ?? "" }
        return Formatters.measurement.string(from: Measurement(value: Double(value), unit: unit))
    }

    let lineHeight: CGFloat = 1

    public var body: some View {
        ZStack(alignment: .leading) {

            // Filltrack
            GeometryReader { reader in
                ZStack(alignment: .leading) {
                    Color(NSColor.controlBackgroundColor)
                    (self.isActive ? Color.accentColor : Color(self.inactiveColor))
                        .frame(width: reader.size.width * self.mappedValue(Double(self.value)),
                               height: self.lineHeight)
                        .offset(x: 0, y: reader.size.height / 2.0 - self.lineHeight / 2)
                }
                .gesture(self.sliderGesture(forWidth: reader.size.width))
            }

            HStack {
                Text(name)
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .allowsHitTesting(false)
                Spacer()
                Text(formattedValue)
                .font(Font(NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .bold)))
                    .multilineTextAlignment(.trailing)
                    .textFieldStyle(PlainTextFieldStyle())
                .fixedSize()
                .allowsHitTesting(false)
            }
            .padding(.horizontal, 8)
        }
        .frame(minWidth: 100)
        .frame(height: 20)
//        .onTapGesture(count: 2) {
//            self.isEditing = true
//        }
//        .onTapGesture(count: 1) {
//            self.isEditing = false
//        }

    }
}

struct ComboSlider_Previews: PreviewProvider {
    static var previews: some View {
        ComboSlider(name: "Intensity", value: .constant(0.4))
    }
}

