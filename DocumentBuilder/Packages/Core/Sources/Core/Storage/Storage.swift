//
//  File.swift
//  
//
//  Created by Михаил Серегин on 24.10.2023.
//

import Foundation
import CoreData
import Dependencies

enum PersistentKey: DependencyKey {
    static var liveValue: PersistentProtocol = Persistent()
    static var previewValue: PersistentProtocol = Persistent(inMemory: true)
    static var testValue: PersistentProtocol = Persistent(inMemory: true)
}

extension DependencyValues {
    var persistent: PersistentProtocol {
        get { self[PersistentKey.self] }
        set { self[PersistentKey.self] = newValue }
    }
}

final class Persistent: PersistentProtocol {
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    init(inMemory: Bool = false) {
        guard let url = Bundle.module.url(forResource: "DocumentBuilder", withExtension: ".momd") else {
            fatalError("model not found")
        }
        guard let managedObject = NSManagedObjectModel(contentsOf: url) else {
            fatalError("managed object was not created")
        }
        container = NSPersistentContainer(name: "DocumentBuilder", managedObjectModel: managedObject)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

public protocol PersistentProtocol {
    var context: NSManagedObjectContext { get }
    func save()
}
