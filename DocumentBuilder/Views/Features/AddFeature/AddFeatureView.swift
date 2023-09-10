//
//  AddFeatureView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 05.09.2023.
//

import SwiftUI
import RichTextKit

struct AddFeatureView: View {
    @ObservedObject var viewModel: AddFeatureViewModel
    @State var isPresented = false
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Создано:")
                    Text(viewModel.createdAt.formatted(.dateTime))
                    Spacer()
                    Button(action: {
                        isPresented = true
                    }) {
                        Image(systemName: "textformat.abc")
                    }
                    .popover(isPresented: $isPresented, content: {
                        RichTextFormatSidebar(context: RTFContext.context)
                            .frame(maxWidth: 300)
                    })
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                HStack {
                    Text("Модуль:")
                    viewModel.module?.title.map(Text.init)
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                TextField("Название фичи", text: $viewModel.title)
                    .font(.largeTitle)
                    .textFieldStyle(.plain)
                HStack {
                    RichTextEditor(
                        text: $viewModel.attributedString,
                        context: RTFContext.context
                    )
                    .frame(minHeight: 500)
                }
            }
            .padding(16)
            .frame(minWidth: 600)
            .toolbar {
                ToolbarItem {
                    Button(action: viewModel.save) {
                        Text("Сохранить")
                    }
                }
            }
            .navigationSplitViewStyle(.prominentDetail)
        }
    }
}

struct AddFeatureView_Previews: PreviewProvider {
    static var previews: some View {
        AddFeatureView(viewModel: .init(moduleId: UUID(), onSave: {}))
    }
}
