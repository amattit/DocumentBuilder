//
//  ServiceRepositoryTests.swift
//  DocumentBuilderTests
//
//  Created by Михаил Серегин on 10.09.2023.
//

import XCTest
import Dependencies

@testable import DocumentBuilder

final class ServiceRepositoryTests: XCTestCase {
    var serviceMock: [Service]!
    var persistent: Persistent!
    var module: Module!
    var moduleId: UUID!
    var serviceRepository: ServiceRepository!
    
    override func setUpWithError() throws {
        persistent = Persistent(inMemory: true)
        moduleId = UUID()
        module = Module(context: persistent.context)
        module.id = moduleId
        
        serviceMock = (0..<4).map {
            let service = Service(context: persistent.context)
            service.id = UUID()
            service.title = "Service \($0)"
            service.parentId = moduleId
            service.path = "/api/v1/service\($0)"
            service.method = "GET"
            return service
        }
        
        persistent.save()
        
        serviceRepository = withDependencies({ dependency in
            dependency.persistent = persistent
        }, operation: {
            ServiceRepository()
        })
    }
    
    override func tearDownWithError() throws {
        serviceMock = nil
        persistent = nil
        moduleId = nil
    }
    
    func testGetServices() throws {
        let services = try serviceRepository.getServices(for: module)
        XCTAssertTrue(services.count == serviceMock.count)
    }
    
    func testDeleteService() throws {
        let services = try serviceRepository.getServices(for: module)
        print(services.count)
        guard let first = services.first else { throw NSError(domain: "no content", code: 0)}
        serviceRepository.delete(first)
        let newServices = try serviceRepository.getServices(for: module)
        print(newServices.count)
        XCTAssertTrue(services.count != newServices.count)
    }
}
