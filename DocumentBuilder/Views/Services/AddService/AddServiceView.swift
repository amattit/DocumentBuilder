//
//  AddServiceView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 08.09.2023.
//

import SwiftUI

struct AddServiceView: View {
    @ObservedObject var viewModel: AddServiceViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Добавить Сервис")
                        .font(.largeTitle)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Название")
                        TextField("Введите имя сервиса, например, \"Запрос на создание задачи\"", text: $viewModel.title)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Относительный путь")
                            Text(viewModel.relativePath + viewModel.queryString)
                        }
                        TextField("/some/path"+viewModel.queryString, text: $viewModel.relativePath)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        if viewModel.queryViewModel == nil {
                            HStack(alignment: .bottom) {
                                Text("Добавьте query параметры")
                                    .font(.title)
                                Button(action: viewModel.createQueryViewModel) {
                                    Image(systemName: "plus")
                                }
                            }
                            Text("если они нужны")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // MARK: - Query parameters
                    if let queryViewModel = viewModel.queryViewModel {
                        QueryParametersView(viewModel: queryViewModel)
                        Button(action: viewModel.removeQueryModel) {
                            HStack {
                                Text("Удалить")
                                Image(systemName: "trash")
                            }
                        }
                        .accentColor(.red)
                    }
                    
                    HStack {
                        Text("HTTP method")
                        Menu {
                            ForEach(viewModel.methods) { item in
                                Button(action: {
                                    viewModel.method = item
                                }) {
                                    Text(item.rawValue)
                                }
                            }
                        } label: {
                            Text(viewModel.method.rawValue)
                        }
                        .menuStyle(.button)
                        .frame(maxWidth: 300)
                    }
                    
                    // MARK: - Headers
                    VStack(alignment: .leading, spacing: 6) {
                        HeaderView(viewModel: viewModel.headerViewModel)
                    }
                    
                    // MARK: - Request
                    VStack(alignment: .leading, spacing: 6) {
                        if viewModel.requestModel == nil {
                            HStack(alignment: .bottom) {
                                Button(action: {
                                    viewModel.createRequestModel()
                                }) {
                                    Text("Добавьте")
                                }
                                .buttonStyle(.link)
                                .font(.title)
                                
                                Text("или")
                                    .font(.title)
                                
                                NavigationLink(value: Navigate.selectRqModel) {
                                    Text("выберите")
                                }
                                .buttonStyle(.link)
                                .font(.title)
                                
                                Text("модель запроса")
                                    .font(.title)
                            }
                            Text("если она нужна")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        if let requestModel = viewModel.requestModel {
                            DataModelView(viewModel: requestModel)
                            Button(action: viewModel.removeRequestModel) {
                                HStack {
                                    Text("Удалить")
                                    Image(systemName: "trash")
                                }
                            }
                            .accentColor(.red)
                        }
                    }
                    
                    // MARK: - Response
                    VStack(alignment: .leading, spacing: 6) {
                        if viewModel.responseModel == nil {
                            HStack(alignment: .bottom) {
                                Button(action: {
                                    viewModel.createRequestModel()
                                }) {
                                    Text("Добавьте")
                                }
                                .buttonStyle(.link)
                                .font(.title)
                                
                                Text("или")
                                    .font(.title)
                                
                                NavigationLink(value: Navigate.selectRqModel) {
                                    Text("выберите")
                                }
                                .buttonStyle(.link)
                                .font(.title)
                                
                                Text("модель ответа")
                                    .font(.title)
                            }
                            Text("если она нужна")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        if let responseModel = viewModel.responseModel {
                            DataModelView(viewModel: responseModel)
                            Button(action: viewModel.removeResponsemodel) {
                                HStack {
                                    Text("Удалить")
                                    Image(systemName: "trash")
                                }
                            }
                            .accentColor(.red)
                        }
                    }
                    
                    Button(action: viewModel.save) {
                        Text("Сохранить")
                    }
                }
                .padding(16)
            }
            .navigationDestination(for: Navigate.self) { item in
                switch item {
                case .selectRqModel:
                    VStack {
                        Text("Выбрать Модель запроса")
                        Spacer()
                    }
                case .selectRsModel:
                    Text("Выбрать Модель ответа")
                }
            }
        }
    }
}

struct AddServiceView_Previews: PreviewProvider {
    static var previews: some View {
        AddServiceView(viewModel: .init(module: .preview))
            .frame(width: 700, height: 800)
    }
}


enum Method: String, CaseIterable, Hashable {
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

extension Method: Identifiable {
    var id: Int { hashValue }
}

extension AddServiceView {
    enum Navigate: Hashable {
        case selectRqModel
        case selectRsModel
    }
}
