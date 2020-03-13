//
//  Optional-Extensions.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

import Foundation

public protocol OptionalConvertible {
    associatedtype Wrapped
    func asOptional() -> Wrapped?
}

extension Optional: OptionalConvertible {
    public func asOptional() -> Wrapped? {
        return self
    }
}
