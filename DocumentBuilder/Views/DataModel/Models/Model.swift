//
//  Model.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 09.09.2023.
//

import Foundation

struct Model: Identifiable, Hashable {
    var id: UUID
    var title: String
    var subtitle: String
    var type: ModelType
    
    static var empty = Model(id: .init(), title: "", subtitle: "", type: .unknown)
}

struct ModelAttribute: Identifiable, Hashable {
    var id: UUID
    var title: String
    var type: String
    var isRequired: Bool
    var comment: String
    var parentId: UUID
}

enum ModelType: String, Hashable {
    case plain, network, view, unknown, db
}
