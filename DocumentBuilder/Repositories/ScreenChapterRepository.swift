//
//  ScreenChapterRepository.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 23.09.2023.
//

import Foundation
import Dependencies

protocol ScreenChapterRepositoryProtocol {
    func getScreenChapters() throws -> [ScreenChapter]
    func createScreenChapter(from model: ScreenChapterModel) throws
    func update(_ screenChapter: ScreenChapter, with model: ScreenChapterModel) throws
    func delete(_ screenChapter: ScreenChapter) throws
}

final class ScreenChapterRepository: ScreenChapterRepositoryProtocol {
    @Dependency(\.persistent) var store
    
    func getScreenChapters() throws -> [ScreenChapter] {
        let request = ScreenChapter.fetchRequest()
        request.predicate = NSPredicate(format: "deletedAt == nil")
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ScreenChapter.createdAt, ascending: true)
        ]
        
        return try store.context.fetch(request)
    }
    
    func createScreenChapter(from model: ScreenChapterModel) throws {
        let entity = ScreenChapter(context: store.context)
        entity.id = model.id
        entity.title = model.title
        entity.createdAt = Date()
        try store.context.save()
    }
    
    func update(_ screenChapter: ScreenChapter, with model: ScreenChapterModel) throws {
        screenChapter.title = model.title
        screenChapter.updatedAt = Date()
        try store.context.save()
    }
    
    func delete(_ screenChapter: ScreenChapter) throws {
        screenChapter.deletedAt = Date()
        try store.context.save()
    }
}

enum ScreenChapterRepositoryKey: DependencyKey {
    public static var liveValue: ScreenChapterRepositoryProtocol = ScreenChapterRepository()
    public static var testValue: ScreenChapterRepositoryProtocol = ScreenChapterRepository()
    public static var previewValue: ScreenChapterRepositoryProtocol = ScreenChapterRepository()
}

extension DependencyValues {
    var screenChapterRepository: ScreenChapterRepositoryProtocol {
        get { self[ScreenChapterRepositoryKey.self] }
        set { self[ScreenChapterRepositoryKey.self] = newValue }
    }
}
