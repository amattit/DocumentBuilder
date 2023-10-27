////
////  AddFeatureViewModel.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 05.09.2023.
////
//
//import Foundation
//import Dependencies
//import CoreData
//import RichTextKit
//
//final class AddFeatureViewModel: ObservableObject {
//    @Dependency(\.persistent) private var store
//    
//    @Published var title = ""
//    @Published var description = ""
//    @Published var attributedString: NSAttributedString = .init(string: "")
//    @Published var createdAt = Date()
//    @Published var module: Module?
//    @Published var context = RichTextContext()
//    
//    let moduleId: UUID?
//    let onSave: () -> Void
//    
//    init(moduleId: UUID?, onSave: @escaping () -> Void) {
//        self.moduleId = moduleId
//        self.onSave = onSave
//        loadModule()
//    }
//    
//    func loadModule() {
//        let request = Module.fetchRequest()
//        do {
//            self.module = try store.context.fetch(request).first
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func save() {
//        let _ = Feature.makeModel(
//            with: title,
//            subtitle: attributedString.string,
//            createdAt: createdAt,
//            parentId: moduleId,
//            attributedText: attributedString,
//            context: store.context
//        )
//        do {
//            try store.context.performAndWait {
//                try store.context.save()
//                onSave()
//            }
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//}
//
//extension Feature {
//    static func makeModel(
//        with title: String,
//        subtitle: String,
//        createdAt: Date,
//        parentId: UUID?,
//        attributedText: NSAttributedString,
//        context: NSManagedObjectContext
//    ) -> Feature {
//        let feature = Feature(context: context)
//        feature.id = UUID()
//        feature.title = title
//        feature.featureDescription = subtitle
//        feature.createdAt = createdAt
//        feature.attributedText = attributedText
//        feature.parentId = parentId
//        return feature
//    }
//}
