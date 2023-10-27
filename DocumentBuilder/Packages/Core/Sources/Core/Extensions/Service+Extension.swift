//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import Foundation

extension Service {
    var wrappedTitle: String {
        self.title ?? ""
    }
    
    var wrappedPath: String {
        self.path ?? ""
    }
    
    var wrappedMethod: String {
        self.method ?? "OPTIONS"
    }
    
    var wrappedHeaders: [Header] {
        self.headers?.toArray() ?? []
    }
    
    var wrappedQuery: [DataModelAttributes] {
        self.query?.toArray() ?? []
    }
}

