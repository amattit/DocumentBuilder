//
//  Networking.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 08.10.2023.
//

import Foundation
import Dependencies

final class Networking {
    private let cache = URLCache(memoryCapacity: 10000, diskCapacity: 10000)
    private var session: URLSession {
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .returnCacheDataElseLoad
        session.configuration.urlCache = cache
        return session
    }
    
    func call(api: API) async throws -> (Data, URLResponse) {
        let request = try api.build()
        return try await session.data(for: request)
    }
}

struct API: Hashable {
    
    let baseUrl: String
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let query: [String: String]
    
    func build() throws -> URLRequest {
        guard let url = URL(string: baseUrl + path)
        else { throw Error.badUrl }
        var request = URLRequest(url: url, timeoutInterval: 60)
        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.key)
        }
        let queryItems = query.map {
            URLQueryItem(name: $0.0, value: $0.1)
        }
        request.url?.append(queryItems: queryItems)
        request.httpMethod = method.value
        
        return request
    }
    
}

enum HTTPMethod: String {
    case get, post, put, path
    
    var value: String {
        rawValue.uppercased()
    }
}


extension Networking: DependencyKey {
    static var liveValue: Networking = Networking()
    static var testValue: Networking = Networking()
}

extension DependencyValues {
    var networking: Networking {
        get { self[Networking.self] }
        set { self[Networking.self] = newValue }
    }
}

