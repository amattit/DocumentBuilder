//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import SwiftUI

struct HTTPMethodView: View {
    let items: [HTTPMethod] = HTTPMethod.allCases
    @Binding var selected: HTTPMethod

    var body: some View {
        HStack {
            Text("HTTP метод")
            Menu {
                ForEach(items) { item in
                    Button(action: {
                        selected = item
                    }) {
                        Text(item.rawValue)
                    }
                }
            } label: {
                Text(selected.rawValue)
            }
            .menuStyle(.button)
            .frame(maxWidth: 300)
            .focusable()
        }
    }
}

enum HTTPMethod: String, CaseIterable, Hashable {
    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, CONNECT, TRACE

    init?(rawValue: String) {
        switch rawValue {
        case "GET":
            self = .GET
        case "POST":
            self = .POST
        case "PUT":
            self = .PUT
        case "PATCH":
            self = .PATCH
        case "DELETE":
            self = .DELETE
        case "HEAD":
            self = .HEAD
        case "OPTIONS":
            self = .OPTIONS
        case "CONNECT":
            self = .CONNECT
        case "TRACE":
            self = .TRACE
        default:
            self = .OPTIONS
        }
    }
}

extension HTTPMethod: Identifiable {
    var id: Int { hashValue }
}
