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
    
    static var empty = Model(id: .init(), title: "", subtitle: "")
}

struct ModelAttribute: Identifiable, Hashable {
    var id: UUID
    var title: String
    var type: String
    var isRequired: Bool
    var comment: String
    var parentId: UUID
}

enum ModelType: String, Identifiable, Hashable {
    case plain, network, view, unknown, db
    var id: Int { hashValue }
}

extension Model {
    init(with object: DataModel) throws {
        guard let id = object.id else { throw Error.noId }
        self.init(
            id: id,
            title: object.title ?? "",
            subtitle: object.subtitle ?? ""
        )
    }
}

extension ModelAttribute {
    init(with object: DataModelAttributes) throws {
        guard let id = object.id, let parentId = object.parentId else { throw Error.noId }
        self.init(
            id: id,
            title: object.title ?? "",
            type: object.objectType ?? "",
            isRequired: object.isRequired,
            comment: object.comment ?? "",
            parentId: parentId
        )
    }
}

