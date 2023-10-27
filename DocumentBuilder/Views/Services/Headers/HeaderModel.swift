////
////  Model.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 17.09.2023.
////
//
//import Foundation
//
//struct HeaderModel: Identifiable, Hashable {
//    var id: UUID
//    var title: String
//    var value: String
//    var subtitle: String
//    var parentId: UUID?
//}
//
//extension HeaderModel {
//    init(with object: Header) throws {
//        guard let id = object.id else { throw Error.noId }
//        self.init(id: id, title: object.title ?? "", value: object.value ?? "", subtitle: object.subtitle ?? "")
//    }
//}
