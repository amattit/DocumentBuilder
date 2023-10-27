////
////  Persistence.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 03.09.2023.
////
//
//import CoreData
//import Dependencies
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    static var preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        for i in 0..<4 {
//            let item = Module(context: viewContext)
//            item.createdAt = Date()
//            item.id = UUID()
//            item.title = "Новый модуль \(i)"
//            item.subtitle = "Описание модуля \(i)"
//        }
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        return result
//    }()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "DocumentBuilder")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//}
//
//enum PersistentKey: DependencyKey {
//    static var liveValue: PersistentProtocol = Persistent()
//    static var previewValue: PersistentProtocol = Persistent(inMemory: true)
//    static var testValue: PersistentProtocol = Persistent(inMemory: true)
//}
//
//extension DependencyValues {
//    var persistent: PersistentProtocol {
//        get { self[PersistentKey.self] }
//        set { self[PersistentKey.self] = newValue }
//    }
//}
//
//final class Persistent: PersistentProtocol {
//    let controller = PersistenceController()
//    let container: NSPersistentContainer
//    
//    var context: NSManagedObjectContext {
//        container.viewContext
//    }
//    
//    init(inMemory: Bool = false) {
//        self.container = NSPersistentContainer(name: "DocumentBuilder")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//    
//    func save() {
//        do {
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}
//
//protocol PersistentProtocol {
//    var context: NSManagedObjectContext { get }
//    func save()
//}
