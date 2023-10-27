import XCTest
import Dependencies
@testable import Core

final class CoreTests: XCTestCase {
    @Dependency(\.persistent) var store
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
        XCTAssertFalse(store.context.hasChanges)
        
    }
    
    func testDataModel() throws {
        let dataModel = DataModel(context: store.context)
        dataModel.id = UUID()
        dataModel.title = "TestModel"
        dataModel.subtitle = "TestSubtitle"
        dataModel.createdAt = Date()
        
        _ = (0..<4).map {
            let attribute = DataModelAttributes(context: store.context)
            attribute.id = .init()
            attribute.title = "attr \($0)"
            attribute.createdAt = Date()
            attribute.model = dataModel
            return attribute
        }
        
        store.save()
        
        let request = DataModel.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DataModel.createdAt, ascending: true)]
        
        let model = try store.context.fetch(request)
        
        XCTAssertEqual(model.count, 1)
        XCTAssertEqual(model.first?.attributes?.count, 4)
    }
}
