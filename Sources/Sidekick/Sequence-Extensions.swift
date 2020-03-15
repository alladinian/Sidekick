//
//  Sequence-Extensions.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

import Foundation

public extension Sequence {
    /// Simplification for `objects.compactMap { $0 as? CastType }`
    /// - Parameter type: The target cast Type
    /// - Returns: A list of objects that could be casted
    func castMap<CastType>(_ type: CastType.Type) -> [CastType] {
        compactMap({ $0 as? CastType })
    }
}

public extension Sequence where Element: OptionalConvertible {
    /// Simplification for `objects.compactMap { $0 }`
    /// - Returns: All non-nil elements
    func compacted() -> [Element.Wrapped] {
        compactMap { $0.asOptional() }
    }
}

public extension Sequence where Element == URLQueryItem {
    /// Simplification for getting a URLQueryItem by name
    /// - Parameter name: The name of the item
    /// - Returns: The value of the item
    func valueFor(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}
