//
//  ScreenView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 19.09.2023.
//

import Foundation
import SwiftUI

struct ScreenView: View {
    @ObservedObject var viewModel: ScreenViewModel

    var body: some View {
        ScrollView {
            HStack {
                ForEach(viewModel.states) { state in
                    Button(state.state) {
                        viewModel.select(state)
                    }
                }
                Button("Добавить") {
                    viewModel.present = .add
                }
            }
            TitleView
            TypeView
            SelectedState
        }
        .sheet(item: $viewModel.present) { item in
            switch item {
            case .add:
                AddScreenStateView(viewModel: AddScreenStateViewModel(screenModel: viewModel.item))
            }
        }
    }
    
    var TitleView: some View {
        TextField("Название экрана", text: $viewModel.item.title)
            .font(.largeTitle)
            .textFieldStyle(.plain)
    }
    
    var TypeView: some View {
        HStack {
            Text(viewModel.item.type.rawValue)
            Spacer()
        }
    }
    
    @ViewBuilder
    var SelectedState: some View {
        ScreenStateView(viewModel: .init(state: viewModel.selectedState))
            .id(viewModel.selectedState?.state.id ?? UUID().uuidString)
    }
}

import Dependencies

final class ScreenViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    
    @Published var item: ScreenModel
    @Published var states: [ScreenStateModel] = []
    @Published var selectedState: ScreenStateModel?
    @Published var present: Present?
    
    init(item: ScreenModel) {
        self.item = item
        load()
    }
    
    func load() {
        do {
            let request = ScreenState.fetchRequest()
            request.predicate = NSPredicate(format: "parentId == %@", item.id.uuidString)
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \ScreenState.createdAt, ascending: true)
            ]
            self.states = try store.context.fetch(request).compactMap({ screenState in
                guard let id = screenState.id, let parentId = screenState.parentId else { return nil }
                return ScreenStateModel(id: id, parentId: parentId, state: screenState.state ?? "N/A", layoutLink: screenState.layoutLink ?? "N/a")
            })
            self.selectedState = states.first
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func select(_ state: ScreenStateModel) {
        self.selectedState = state
    }
}

extension ScreenViewModel {
    enum Present: Identifiable, Hashable {
        case add
        
        var id: Int {
            self.hashValue
        }
    }
}
