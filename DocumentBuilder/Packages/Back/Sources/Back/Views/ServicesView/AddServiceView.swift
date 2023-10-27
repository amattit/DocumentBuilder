//
//  File.swift
//  
//
//  Created by Михаил Серегин on 27.10.2023.
//

import SwiftUI
import Dependencies
import Core

struct AddServiceView: View {
    @ObservedObject var viewModel: AddServiceViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Добавить сервис")
                .font(.title)
            TextField("Бизнес название сервиса", text: $viewModel.title)
            TextField("Относительный путь", text: $viewModel.path)
            HTTPMethodView(selected: $viewModel.method)
            
            HStack {
                Button("Закрыть") {
                    viewModel.close()
                }
                
                Button("Сохранить") {
                    Task {
                        await viewModel.add()
                    }
                }
            }
        }
        .onChange(of: viewModel.needToClose) { newValue in
            if newValue {
                presentation.wrappedValue.dismiss()
            }
        }
    }
    
}

final class AddServiceViewModel: ObservableObject {
    @Published var title = ""
    @Published var path = ""
    @Published var needToClose = false
    @Published var method: HTTPMethod = .GET
    // Добавить новые параметры
    @Published var advanced = false
    
    private let repository: ServiceRepository
    private let module: Module
    
    private let logger = Logger(module: "AddServiceViewModel")
    
    init(module: Module) {
        self.repository = .init(module: module)
        self.module = module
    }
    
    func add() async {
        do {
            try await repository.fastCreate(with: title, path: path, method: method.rawValue)
            close()
        } catch {
            logger.error(message: error.localizedDescription)
            close()
        }
    }
    
    func close() {
        needToClose = true
    }
}
