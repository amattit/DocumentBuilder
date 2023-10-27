//
//  SwiftUIView.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import SwiftUI
import Core

struct ServiceView: View {
    @Environment(\.presentationMode) var present
    @ObservedObject var viewModel: ServiceViewModel
    
    var body: some View {
        HSplitView(content: {
            ScrollView {
                TextField("Название", text: $viewModel.title)
                    .font(.largeTitle)
                    .textFieldStyle(.plain)
                TextField("Относительный путь", text: $viewModel.path)
                httpMethod
            }
            .frame(minWidth: 400)
            VStack(alignment: .leading) {
                if viewModel.isAddHeadersAvailable() {
                    Button("+ заголовки") {
                        viewModel.showAddHeaders()
                    }
                    
                    
                }
                
                if viewModel.isAddRequestModelAvailable() {
                    Button("+ модель запроса") {
                        viewModel.showAddRequest()
                    }
                    
                    Text("или выберите")
                }
                
                if viewModel.isAddResponseModelAvailable() {
                    Button("+ модель ответа") {
                        viewModel.showAddResponse()
                    }
                    
                    Text("или выберите")
                }
                
                Spacer()
            }
            .padding()
        })
        .sheet(item: $viewModel.present) { item in
            switch item {
            case .addHeaders:
                ModalWrapper {
                    HeadersView(items: $viewModel.headers, selection: $viewModel.selectedHeaders)
                } actions: {
                    modalActions
                }

            case .addRequest:
                ModalWrapper {
                    Text("Добавить модель запроса")
                } actions: {
                    modalActions
                }
            case .addResponse:
                ModalWrapper {
                    Text("Добавить модель ответа")
                } actions: {
                    modalActions
                }
            }
        }
    }
    
    var httpMethod: some View {
        HTTPMethodView(selected: $viewModel.method)
    }
    
    @ViewBuilder
    var modalActions: some View {
        Button("Сохранить") {
            present.wrappedValue.dismiss()
        }
        Spacer()
        Button("Закрыть") {
            present.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ContentView()
//    ServiceView(viewModel: .init())
//        .frame(minWidth: 500, minHeight: 600)
}

final class ServiceViewModel: ObservableObject {
    @Published var title = ""
    @Published var path = ""
    
    @Published var method: HTTPMethod = .GET
    @Published var present: Present?
    
    // Заголовоки
    @Published var headers: [HeadersView.HeaderModel] = []
    @Published var selectedHeaders: Set<HeadersView.HeaderModel.ID> = []
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
        self.title = service.title ?? ""
        self.path = service.path ?? ""
        self.method = HTTPMethod(rawValue: service.method ?? "") ?? .GET
    }
    
    func isAddHeadersAvailable() -> Bool {
        true
    }
    
    func isAddRequestModelAvailable() -> Bool {
        true
    }
    
    func isAddResponseModelAvailable() -> Bool {
        true
    }
    
    func showAddHeaders() {
        self.present = .addHeaders
    }
    
    func showAddRequest() {
        self.present = .addRequest
    }
    
    func showAddResponse() {
        self.present = .addResponse
    }
}

extension ServiceViewModel {
    enum Present: Identifiable, Hashable {
        case addRequest, addResponse, addHeaders
        
        var id: Int {
            hashValue
        }
    }
}
