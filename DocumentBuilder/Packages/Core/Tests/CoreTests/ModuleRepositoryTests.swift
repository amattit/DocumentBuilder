//
//  File.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import XCTest
@testable import Core

final class ModuleRepositoryTests: XCTestCase {
    private let title = "Title"
    private let subtitle = "Subtitle"
    
    var sut: ModuleRepository!
    
    override func setUpWithError() throws {
        sut = .init()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testCreateModule() async throws {
        // Создаем модуль
        try await createModule()
        
        // Получаем список моулей
        let items = try await sut.getModules()
        
        // Проверяем
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.title, title)
        XCTAssertEqual(items.first?.subtitle, subtitle)
    }
    
    func testUpdateModule() async throws {
        // Создаем модуль
        try await createModule()
        
        // Получаем первый модуль
        let items = try await sut.getModules()
        XCTAssertEqual(items.count, 1)
        let id = try XCTUnwrap(items.first?.id)
        
        // Обновляем модуль
        try await sut.update(title: "Title 1", subtitle: "Subtitle 1", moduleId: id)
        
        // Проверяем параметры
        XCTAssertEqual(items.first?.title, "Title 1")
        XCTAssertEqual(items.first?.subtitle, "Subtitle 1")
        
    }
    
    func testDelete() async throws {
        try await createModule()
        
        // Получаем первый модуль
        let items = try await sut.getModules()
        XCTAssertEqual(items.count, 1)
        let id = try XCTUnwrap(items.first?.id)
        try await sut.delete(module: id)
        
        // Проверяем, что база пустая
        let checkItems = try await sut.getModules()
        XCTAssertEqual(checkItems.count, 0)
    }
    
    func testLifecycle() async throws {
        try await createModule()
        let items = try await sut.getModules()
        let first = try XCTUnwrap(items.first)
        let id = try XCTUnwrap(first.id)
        
        try await sut.update(title: "1", subtitle: "2", moduleId: id)
        
        try await sut.delete(module: id)
        
        let check = try await sut.getModules()
        XCTAssertEqual(check.count, 0)
    }
    
    private func createModule() async throws {
        try await sut.create(title, subtitle: subtitle)
    }
}
