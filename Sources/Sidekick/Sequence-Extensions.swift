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
    func compacted() -> [Element.Wrapped] {
        compactMap { $0.asOptional() }
    }
}

public extension Sequence where Element == URLQueryItem {
    func valueFor(_ name: String) -> String? {
        first(where: { $0.name == name })?.value
    }
}
