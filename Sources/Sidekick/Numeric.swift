//
//  Numeric.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

import Foundation

public extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

public extension Strideable where Stride: SignedInteger {
    func clamped(to limits: CountableClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

public func map<V: BinaryFloatingPoint>(value: V, from: ClosedRange<V>, to: ClosedRange<V>) -> V {
    let (low1, high1) = (from.lowerBound, from.upperBound)
    let (low2, high2) = (to.lowerBound, to.upperBound)
    return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
}
