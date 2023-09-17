//
//  TasksView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 17.09.2023.
//

import SwiftUI
import Dependencies
import CoreData

struct TasksView: View {
    enum FocusField: Hashable {
        case newTask
    }
    
    @ObservedObject var viewModel: TasksViewModel
    @FocusState var focused: FocusField?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach($viewModel.tasks.filter({ model in
                        if viewModel.filter == .open {
                            return model.isDone.wrappedValue == false
                        } else {
                            return true
                        }
                    })) { task in
                        HStack(alignment: .firstTextBaseline) {
                            Toggle(isOn: task.isDone) {
                                EmptyView()
                            }
                            .onChange(of: task.wrappedValue.isDone) { newValue in
                                viewModel.update()
                            }
                            TextField("Название задачи", text: task.text, axis: .vertical)
                                .onSubmit(viewModel.update)
                                .textFieldStyle(.plain)
                        }
                        .font(.title3)
                    }
                }
                TextField("Новая задача", text: $viewModel.title, axis: .vertical)
                    .onSubmit {
                        viewModel.add()
                        focused = .newTask
                    }
                    .focused($focused, equals: .newTask)
            }
            .padding(16)
            .onAppear {
                focused = .newTask
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        if viewModel.filter == .open {
                            viewModel.filter = .all
                        } else {
                            viewModel.filter = .open
                        }
                    }) {
                        Image(systemName: "camera.filters")
                    }
                    .background {
                        viewModel.filter == .open ? Color.gray.opacity(0.5) : .clear
                    }
                    .clipShape(RoundedRectangle(cornerSize: .init(width: 5, height: 5)))
                }
            }
        }
    }
}

struct TaskModel: Hashable, Identifiable {
    let id: UUID
    var text: String
    var createAt: Date
    var isDone: Bool
    
    init(text: String, isDone: Bool) {
        self.id = UUID()
        self.text = text
        self.isDone = isDone
        self.createAt = Date()
    }
    
    init(with object: TaskEntity) {
        id = object.id ?? .init()
        text = object.text ?? .init()
        createAt = object.createdAt ?? .init()
        isDone = object.isDone
    }
}

import Combine

final class TasksViewModel: ObservableObject {
    enum Filter {
        case all
        case open
    }
    @Dependency(\.persistent) var store
    @Published var title = ""
    @Published var tasks: [TaskModel] = []
    @Published var filter = Filter.all
    private var entities: [TaskEntity] = []
    private var disposables = Set<AnyCancellable>()
    
    var displayed: [TaskModel] {
        switch filter {
        case .all:
            return tasks
        case .open:
            return tasks.filter { $0.isDone == false }
        }
    }
    
    init() {
        bind()
        load()
    }
    
    func add() {
        update()
        let task = TaskEntity(context: store.context)
        task.id = .init()
        task.text = title
        task.createdAt = Date()
        task.isDone = false
        
        store.save()
        title = ""
    }
    
    func update() {
        entities.forEach { entity in
            let model = tasks.first { taskModel in
                taskModel.id == entity.id
            }
            entity.text = model?.text
            entity.isDone = model?.isDone ?? false
            
        }
        store.save()
    }
    
    func load() {
        tryAction {
            let request = TaskEntity.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(keyPath: \TaskEntity.isDone, ascending: true),
                NSSortDescriptor(keyPath: \TaskEntity.createdAt, ascending: true),
            ]
            let entities = try store.context.fetch(request)
            self.tasks = entities.map(TaskModel.init)
            self.entities = entities
        }
    }
    
    private func bind() {
        NotificationCenter.default.publisher(for: NSManagedObjectContext.didSaveObjectsNotification)
            .sink { notification in
                self.load()
            }
            .store(in: &disposables)
    }
}
