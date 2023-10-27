////
////  MosuleListViewModel.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 04.09.2023.
////
//
//import Foundation
//import Dependencies
//import Combine
//import CoreData
//import SwiftUI
//
//final class ModuleListViewModel: ObservableObject {
//    @Dependency(\.persistent) var store
//    
//    @Published var modules: [Module] = []
//    @Published var selected: Module?
//    @Published var present: Present?
//    @Published var visibility: NavigationSplitViewVisibility = .all
//    
//    private var disposables = Set<AnyCancellable>()
//    
//    init() {
//        bind()
//        load()
//    }
//    
//    func load() {
//        let request = Module.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Module.createdAt, ascending: true)]
//        request.predicate = NSPredicate(format: "deletedAt == nil")
//        
//        do {
//            self.modules = try store.context.fetch(request)
//            if selected == nil {
//                selected = modules.first
//            } else {
//                if let selected, !modules.contains(where: { $0.id == selected.id }) {
//                    self.selected = modules.first
//                }
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func addModule() {
//        present = .addModule
//    }
//    
//    func delete(_ module: Module) {
//        module.deletedAt = Date()
//        store.save()
//    }
//    
//    private func bind() {
//        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
//            .sink { notification in
//                self.load()
//            }
//            .store(in: &disposables)
//    }
//    
//}
//
//extension ModuleListViewModel {
//    enum Present: Identifiable, Hashable {
//        case addModule
//        
//        var id: Int {
//            self.hashValue
//        }
//    }
//}
