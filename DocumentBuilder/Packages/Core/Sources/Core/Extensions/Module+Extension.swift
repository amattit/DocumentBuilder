//
//  File.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import Foundation

public extension Module {
    var wrappedTitle: String {
        self.title ?? ""
    }
    
    var wrappedServices: [Service] {
        Array((self.services as? Set<Service>) ?? [])
    }
    
    var wrappedDTOs: [DataModel] {
        Array((self.dataModels as? Set<DataModel>) ?? [])
    }
}
