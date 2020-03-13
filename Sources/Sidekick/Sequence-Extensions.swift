//
//  Sequence-Extensions.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

import Foundation

extension Sequence {
    /// Simplification for `objects.compactMap { $0 as? CastType }`
    /// - Parameter type: The target cast Type
    /// - Returns: A list of objects that could be casted
    func castMap<CastType>(_ type: CastType.Type) -> [CastType] {
        compactMap({ $0 as? CastType })
    }
}

extension Sequence where Element: OptionalConvertible {
    /// Simplification for `objects.compactMap { $0 }`
    func compacted() -> [Element.Wrapped] {
        return compactMap { $0.asOptional() }
    }
}
