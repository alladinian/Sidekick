//
//  Predicates.swift
//  
//
//  Created by Vasilis Akoinoglou on 15/3/20.
//

import Foundation
import CoreData

public func && (left: NSPredicate?, right: NSPredicate?) -> NSCompoundPredicate {
    NSCompoundPredicate(andPredicateWithSubpredicates: [left, right].compacted())
}

public func || (left: NSPredicate, right: NSPredicate) -> NSCompoundPredicate {
    NSCompoundPredicate(orPredicateWithSubpredicates: [left, right])
}

public func == (left: String, flag: Bool) -> NSPredicate {
    NSPredicate(format: "%K == %@", left, NSNumber(booleanLiteral: flag))
}

public func == (left: String, object: NSObject) -> NSPredicate {
    NSPredicate(format: "%K == %@", left, object)
}

public func ~= (left: String, right: NSObject) -> NSPredicate {
    NSPredicate(format: "ANY %K == %@", left, right)
}

public func === (left: NSManagedObject, right: String) -> NSPredicate {
    NSPredicate(format: "%@ IN %K", left, right)
}

public extension NSManagedObject {
    func `in`(_ collectionPath: String) -> NSPredicate {
        NSPredicate(format: "%@ IN %K", self, collectionPath)
    }
}

public extension String {
    func anyIs(_ object: NSObject) -> NSPredicate {
        NSPredicate(format: "ANY %K == %@", self, object)
    }

    func `is`(_ object: NSObject) -> NSPredicate {
        NSPredicate(format: "%K == %@", self, object)
    }

    func `is`(_ text: String) -> NSPredicate {
        NSPredicate(format: "%K == %@", self, text)
    }

    func `is`(_ flag: Bool) -> NSPredicate {
        NSPredicate(format: "%K == %@", self, NSNumber(booleanLiteral: flag))
    }

    func contains(_ text: String) -> NSPredicate {
        NSPredicate(format: "%K contains[cd] %@", self, text)
    }
}

public extension Array where Element == NSPredicate {
    var orJoined: NSCompoundPredicate {
        NSCompoundPredicate(orPredicateWithSubpredicates: self)
    }

    var andJoined: NSCompoundPredicate {
        NSCompoundPredicate(andPredicateWithSubpredicates: self)
    }
}


// MARK: - typed predicate types
public protocol TypedPredicateProtocol: NSPredicate { associatedtype Root }

public final class CompoundPredicate<Root>: NSCompoundPredicate, TypedPredicateProtocol {}

public final class ComparisonPredicate<Root>: NSComparisonPredicate, TypedPredicateProtocol {}

// MARK: - compound operators
public func && <TP: TypedPredicateProtocol>(p1: TP, p2: TP) -> CompoundPredicate<TP.Root> {
    CompoundPredicate(type: .and, subpredicates: [p1, p2])
}

public func || <TP: TypedPredicateProtocol>(p1: TP, p2: TP) -> CompoundPredicate<TP.Root> {
    CompoundPredicate(type: .or, subpredicates: [p1, p2])
}

public prefix func ! <TP: TypedPredicateProtocol>(p: TP) -> CompoundPredicate<TP.Root> {
    CompoundPredicate(type: .not, subpredicates: [p])
}

// MARK: - comparison operators
public func == <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    ComparisonPredicate(kp, .equalTo, value)
}

public func != <E: Equatable, R, K: KeyPath<R, E>>(kp: K, value: E) -> ComparisonPredicate<R> {
    ComparisonPredicate(kp, .notEqualTo, value)
}

public func > <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    ComparisonPredicate(kp, .greaterThan, value)
}

public func < <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    ComparisonPredicate(kp, .lessThan, value)
}

public func <= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    ComparisonPredicate(kp, .lessThanOrEqualTo, value)
}

public func >= <C: Comparable, R, K: KeyPath<R, C>>(kp: K, value: C) -> ComparisonPredicate<R> {
    ComparisonPredicate(kp, .greaterThanOrEqualTo, value)
}

public func === <S: Sequence, R, K: KeyPath<R, S.Element>>(kp: K, values: S) -> ComparisonPredicate<R> where S.Element: Equatable {
    ComparisonPredicate(kp, .in, values)
}

// MARK: - internal
extension ComparisonPredicate {
    convenience init<VAL>(_ kp: KeyPath<Root, VAL>, _ op: NSComparisonPredicate.Operator, _ value: Any?) {
        let ex1 = \Root.self == kp ? NSExpression.expressionForEvaluatedObject() : NSExpression(forKeyPath: kp)
        let ex2 = NSExpression(forConstantValue: value)
        self.init(leftExpression: ex1, rightExpression: ex2, modifier: .direct, type: op)
    }
}
