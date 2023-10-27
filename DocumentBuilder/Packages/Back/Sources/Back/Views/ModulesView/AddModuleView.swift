//
//  File.swift
//  
//
//  Created by Михаил Серегин on 26.10.2023.
//

import SwiftUI
import Dependencies
import Core

struct AddModuleView: View {
    @ObservedObject var viewModel: AddModuleViewModel
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text("Добавить модуль")
                .font(.title)
            TextField("Название модуля", text: $viewModel.title)
            TextField("Краткое описание модуля", text: $viewModel.subtitle)
            
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

@MainActor
final class AddModuleViewModel: ObservableObject {
    @Dependency(\.modulesRepository) private var repository
    
    @Published var title = ""
    @Published var subtitle = ""
    @Published var needToClose = false
    
    private let logger = Logger(module: "AddModuleViewModel")
    
    func add() async {
        do {
            try await repository.create(title, subtitle: subtitle)
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
