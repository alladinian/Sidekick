//
//  Optional-Extensions.swift
//  
//
//  Created by Vasilis Akoinoglou on 13/3/20.
//

import Foundation

protocol OptionalConvertible {
    associatedtype Wrapped
    func asOptional() -> Wrapped?
}

extension Optional: OptionalConvertible {
    func asOptional() -> Wrapped? {
        return self
    }
}
