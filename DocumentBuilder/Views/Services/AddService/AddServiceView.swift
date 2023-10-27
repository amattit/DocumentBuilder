////
////  AddServiceView.swift
////  DocumentBuilder
////
////  Created by Михаил Серегин on 08.09.2023.
////
//
//import SwiftUI
//
//struct AddServiceView: View {
//    @ObservedObject var viewModel: AddServiceViewModel
//    
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    Text("Добавить Сервис")
//                        .font(.largeTitle)
//                    
//                    ServiceName
//                    
//                    // MARK: - path Относительный путь
//                    RelativePath
//                    
//                    // MARK: - Query parameters
//                    QueryParameters
//                    
//                    // MARK: - HTTP method
//                    HTTPMethod
//                    
//                    // MARK: - Headers
//                    Headers
//                    
//                    // MARK: - Request
//                    Request
//                    
//                    // MARK: - Response
//                    Response
//                    
//                    Button(action: viewModel.save) {
//                        Text("Сохранить")
//                    }
//                }
//                .padding(16)
//            }
//            .navigationDestination(for: Navigate.self) { item in
//                switch item {
//                case .selectRqModel:
//                    VStack {
//                        Text("Выбрать Модель запроса")
//                            .font(.largeTitle)
//                        DataModelListView(viewModel: viewModel.requestModelListViewModel)
//                    }
//                case .selectRsModel:
//                    VStack {
//                        Text("Выбрать Модель ответа")
//                            .font(.largeTitle)
//                        DataModelListView(viewModel: viewModel.responseModelListViewModel)
//                    }
//                }
//            }
//        }
//    }
//    
//    var ServiceName: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Название")
//            TextField("Введите имя сервиса, например, \"Запрос на создание задачи\"", text: $viewModel.title)
//        }
//    }
//    
//    var RelativePath: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack {
//                Text("Относительный путь")
//                Text(viewModel.relativePath + viewModel.queryString)
//            }
//            TextField("/some/path"+viewModel.queryString, text: $viewModel.relativePath)
//        }
//    }
//    
//    var QueryParameters: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            if viewModel.queryViewModel == nil {
//                HStack(alignment: .bottom) {
//                    Text("Добавьте query параметры")
//                        .font(.title)
//                    Button(action: viewModel.createQueryViewModel) {
//                        Image(systemName: "plus")
//                    }
//                }
//                Text("если они нужны")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            
//            if let queryViewModel = viewModel.queryViewModel {
//                QueryParametersView(viewModel: queryViewModel)
//                Button(action: viewModel.removeQueryModel) {
//                    HStack {
//                        Text("Удалить")
//                        Image(systemName: "trash")
//                    }
//                }
//                .accentColor(.red)
//            }
//        }
//    }
//    
//    var HTTPMethod: some View {
//        HTTPMethodView(items: viewModel.methods, selected: $viewModel.method)
//    }
//    
//    var Headers: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            HeaderView(viewModel: viewModel.headerViewModel)
//        }
//    }
//    
//    var Request: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            if viewModel.requestModel == nil && viewModel.requestModelListViewModel.selected == nil {
//                createOrSelectModelView(add: viewModel.createRequestModel, select: Navigate.selectRqModel)
//            }
//            if let requestModel = viewModel.requestModel {
//                DataModelView(viewModel: requestModel)
//                Button(action: viewModel.removeRequestModel) {
//                    HStack {
//                        Text("Удалить")
//                        Image(systemName: "trash")
//                    }
//                }
//                .accentColor(.red)
//            }
//            
//            if let requestModel = viewModel.requestModelListViewModel.selected {
//                Text("Модель запроса")
//                    .font(.largeTitle)
//                HStack {
//                    ModelRowView(model: requestModel)
//                        .font(.title)
//                    Spacer()
//                    Button {
//                        viewModel.requestModelListViewModel.selected = nil
//                    } label: {
//                        Image(systemName: "x.circle.fill")
//                    }
//
//                }
//            }
//        }
//    }
//    
//    var Response: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            if viewModel.responseModel == nil && viewModel.responseModelListViewModel.selected == nil {
//                createOrSelectModelView(add: viewModel.createResponseModel, select: Navigate.selectRsModel)
//            }
//            if let responseModel = viewModel.responseModel {
//                DataModelView(viewModel: responseModel)
//                Button(action: viewModel.removeResponsemodel) {
//                    HStack {
//                        Text("Удалить")
//                        Image(systemName: "trash")
//                    }
//                }
//                .accentColor(.red)
//            }
//            
//            if let responseModel = viewModel.responseModelListViewModel.selected {
//                Text("Модель ответа")
//                    .font(.largeTitle)
//                HStack {
//                    ModelRowView(model: responseModel)
//                        .font(.title)
//                    Spacer()
//                    Button {
//                        viewModel.responseModelListViewModel.selected = nil
//                    } label: {
//                        Image(systemName: "x.circle.fill")
//                    }
//
//                }
//            }
//        }
//    }
//    
//    @ViewBuilder
//    func createOrSelectModelView(add addAction: @escaping () -> Void, select selectAction: Navigate ) -> some View {
//        HStack(alignment: .bottom) {
//            Button(action: addAction) {
//                Text("Добавьте")
//            }
//            .buttonStyle(.link)
//            .font(.title)
//            
//            Text("или")
//                .font(.title)
//            
//            NavigationLink(value: selectAction) {
//                Text("выберите")
//            }
//            .buttonStyle(.link)
//            .font(.title)
//            
//            Text("модель ответа")
//                .font(.title)
//        }
//        Text("если она нужна")
//            .font(.subheadline)
//            .foregroundColor(.secondary)
//    }
//}
//
////struct AddServiceView_Previews: PreviewProvider {
////    static var previews: some View {
////        AddServiceView(viewModel: .init(module: .preview))
////            .frame(width: 700, height: 800)
////    }
////}
//
//
//enum Method: String, CaseIterable, Hashable {
//    case GET, POST, PUT, PATCH, DELETE, HEAD, OPTIONS, CONNECT, TRACE
//    
//    init?(rawValue: String) {
//        switch rawValue {
//        case "GET":
//            self = .GET
//        case "POST":
//            self = .POST
//        case "PUT":
//            self = .PUT
//        case "PATCH":
//            self = .PATCH
//        case "DELETE":
//            self = .DELETE
//        case "HEAD":
//            self = .HEAD
//        case "OPTIONS":
//            self = .OPTIONS
//        case "CONNECT":
//            self = .CONNECT
//        case "TRACE":
//            self = .TRACE
//        default:
//            self = .OPTIONS
//        }
//    }
//}
//
//extension Method: Identifiable {
//    var id: Int { hashValue }
//}
//
//extension AddServiceView {
//    enum Navigate: Hashable {
//        case selectRqModel
//        case selectRsModel
//    }
//}
