//
//  DocumentBuilderTests.swift
//  DocumentBuilderTests
//
//  Created by Михаил Серегин on 03.09.2023.
//

import XCTest
@testable import DocumentBuilder

final class DocumentBuilderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testAPI() throws {
        // https://www.figma.com/file/sAnqEBXL9GcuMEWqxf7hiX/Concept-ISU?type=design&node-id=1393-38098&mode=design&t=5rPDRbalsdCiWQEA-4
        let api = API(
            baseUrl: "https://www.figma.com",
            path: "/file/sAnqEBXL9GcuMEWqxf7hiX/Concept-ISU",
            method: .get,
            headers: ["X-FIGMA-TOKEN":"figd_OnxDKon4jFVyrIdWFxvrMEOMkaYD_3BqL6HEvU8F"],
            query: [
                "ids": "1393-38098",
                "scale": "1"
            ]
        )
        
        let request = try api.build()
        
        let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
        XCTAssertEqual(components?.host, "www.figma.com")
        XCTAssertEqual(components?.path, "/file/sAnqEBXL9GcuMEWqxf7hiX/Concept-ISU")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
