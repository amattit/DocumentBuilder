//
//  ServiceRowView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 10.09.2023.
//

import SwiftUI

struct ServiceRowView: View {
//    @ObservedObject var viewModel: ServiceRowViewModel
    let service: Service
    var body: some View {
        HStack {
            MethodView(method: method)
            VStack(alignment: .leading) {
                Text(path)
                    .font(.body)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
    var path: String {
        service.path ?? "N/A"
    }
    
    var title: String {
        service.title ?? "N/A"
    }
    
    var method: Method {
        let method = service.method ?? "TRACE"
        return .init(rawValue: method) ?? .TRACE
    }
}

struct MethodView: View {
    let method: Method
    
    var body: some View {
        Text(method.rawValue)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundColor(.white)
    }
    
    var backgroundColor: Color {
        switch method {
        case .GET:
            return .green
        case .POST:
            return .blue
        case .PATCH:
            return .blue.opacity(0.5)
        case .PUT:
            return .blue.opacity(0.5)
        case .DELETE:
            return .red
        default:
            return .gray
        }
    }
}

//struct ServiceRowView_Preview: PreviewProvider {
//    static var service: Service {
//        let persistent = Persistent(inMemory: true)
//        let service = Service(context: persistent.context)
//        service.id = UUID()
//        service.method = "GET"
//        service.title = "Запрос на получение объекта"
//        service.path = "/api/v1/note/:id"
//        
//        return service
//    }
//    static var previews: some View {
//        
//        ServiceRowView(service: service)
//    }
//}


class ServiceRowViewModel: ObservableObject {
    let service: Service
    init(service: Service) {
        self.service = service
    }
}
