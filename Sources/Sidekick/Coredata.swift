//
//  File.swift
//  
//
//  Created by Vasilis Akoinoglou on 16/3/20.
//

import Foundation
import CoreData

protocol AutoFetchGeneration {}
extension AutoFetchGeneration where Self: NSManagedObject {
    static func fetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: String(describing: T.self))
    }
}

extension NSManagedObject {
    func getterAccess<T>(key: String) -> T? {
        willAccessValue(forKey: key)
        defer { didAccessValue(forKey: key) }
        return primitiveValue(forKey: key) as? T
    }

    func getterAccessOrdered<T>(key: String) -> [T] {
        guard let objects: NSOrderedSet = getterAccess(key: key) else { return [] }
        return (objects.array as? [T]) ?? []
    }

    func setterChange(key: String, value: Any?) {
        willChangeValue(forKey: key)
        defer { didChangeValue(forKey: key) }
        setPrimitiveValue(value, forKey: key)
    }

    func setterChangeOrdered(key: String, value: [Any]?) {
        guard let value = value else {
            setterChange(key: key, value: nil)
            return
        }
        let objects = NSOrderedSet(array: value)
        setterChange(key: key, value: objects)
    }
}

protocol EntityNameProvider: class {
    static var entityName: String { get }
}

extension NSManagedObject: EntityNameProvider {
    static var entityName: String {
        return className()
    }
}

extension EntityNameProvider {

    static func new(in context: NSManagedObjectContext) -> Self {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Self
    }

    static func first(predicate: NSPredicate, sortedBy: String? = nil, ascending: Bool = false, in moc: NSManagedObjectContext) -> Self? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        request.predicate = predicate

        if let s = sortedBy {
            request.sortDescriptors = [NSSortDescriptor(key: s, ascending: ascending)]
        }

        do {
            let fetchedObjects = try moc.fetch(request)
            return fetchedObjects.first as? Self
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }

    static func first(where whereClause: String? = nil, equals: Any? = nil, sortedBy: String? = nil, ascending: Bool = false, in moc: NSManagedObjectContext) -> Self? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if let a = whereClause, let v = equals {
            request.predicate = NSPredicate(format: "%K = %@", argumentArray: [a, v])
        }

        if let s = sortedBy {
            request.sortDescriptors = [NSSortDescriptor(key: s, ascending: ascending)]
        }

        do {
            let fetchedObjects = try moc.fetch(request)
            return fetchedObjects.first as? Self
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }

    static func all(predicate: NSPredicate, sortedBy: String? = nil, ascending: Bool = false, in moc: NSManagedObjectContext) -> [Self] {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        request.predicate = predicate

        if let s = sortedBy {
            request.sortDescriptors = [NSSortDescriptor(key: s, ascending: ascending)]
        }

        do {
            let fetchedObjects = try moc.fetch(request)
            return fetchedObjects as? [Self] ?? []
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }

    static func all(where whereClause: String? = nil, equals: Any? = nil, sortedBy: String? = nil, ascending: Bool = false, in moc: NSManagedObjectContext) -> [Self] {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)

        if let a = whereClause, let v = equals {
            request.predicate = NSPredicate(format: "%K = %@", argumentArray: [a, v])
        }

        if let s = sortedBy {
            request.sortDescriptors = [NSSortDescriptor(key: s, ascending: ascending)]
        }

        do {
            let fetchedObjects = try moc.fetch(request)
            return fetchedObjects as? [Self] ?? []
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
    }

    static func insertOrUpdate(in context: NSManagedObjectContext, lookup: (key: String, value: Any)) -> Self {
        if let match = first(where: lookup.key, equals: lookup.value, in: context) {
            return match
        }
        return Self.new(in: context)
    }

}

extension NSFetchRequestResult where Self: EntityNameProvider {
    static func create(_ context: NSManagedObjectContext, params: [String : Any]? = nil) -> Self {
        let object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Self

        if params == nil {
            return object
        }

        let managedObject = object as! NSManagedObject

        for (key, value) in params! {
            managedObject.willChangeValue(forKey: key)
            managedObject.setValue(value, forKey: key)
            managedObject.didChangeValue(forKey: key)
        }

        return object
    }
}
