//
//  ScreenRepository.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 27.09.2023.
//

import Foundation
import Dependencies

protocol ScreenRepositoryProtocol {
    func getScreens(for chaper: ScreenChapterModel) throws -> [Screen]
    func createScreen(from model: ScreenModel) throws
    func update(_ screen: Screen, with model: ScreenModel) throws
    func delete(_ screen: Screen) throws
}

final class ScreenRepository: ScreenRepositoryProtocol {
    @Dependency(\.persistent) var store
    
    func getScreens(for chaper: ScreenChapterModel) throws -> [Screen] {
        let request = Screen.fetchRequest()
        request.predicate = 
        NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "deletedAt == nil"),
            NSPredicate(format: "parentId == %@", chaper.id.uuidString)
        ])
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Screen.createdAt, ascending: true)
        ]
        
        return try store.context.fetch(request)
    }
    
    func createScreen(from model: ScreenModel) throws {
        let entity = Screen(context: store.context)
        entity.id = model.id
        entity.title = model.title
        entity.type = model.type.rawValue
        entity.parentId = model.parentId
        entity.createdAt = Date()
        try store.context.save()
    }
    
    func update(_ screenChapter: Screen, with model: ScreenModel) throws {
        screenChapter.title = model.title
        screenChapter.updatedAt = Date()
        try store.context.save()
    }
    
    func delete(_ screenChapter: Screen) throws {
        screenChapter.deletedAt = Date()
        try store.context.save()
    }
}

enum ScreenRepositoryKey: DependencyKey {
    public static var liveValue: ScreenRepositoryProtocol = ScreenRepository()
    public static var testValue: ScreenRepositoryProtocol = ScreenRepository()
    public static var previewValue: ScreenRepositoryProtocol = ScreenRepository()
}

extension DependencyValues {
    var screenRepository: ScreenRepositoryProtocol {
        get { self[ScreenRepositoryKey.self] }
        set { self[ScreenRepositoryKey.self] = newValue }
    }
}

