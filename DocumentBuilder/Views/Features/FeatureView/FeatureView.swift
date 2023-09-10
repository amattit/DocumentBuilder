//
//  FeatureView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 08.09.2023.
//

import SwiftUI
import RichTextKit
import Dependencies

struct FeatureView: View {
    @ObservedObject var viewModel: FeatureViewModel
    
    var body: some View {
        HStack(spacing:0 ) {
            VStack(alignment: .leading) {
                
                TextField("Название фичи", text: $viewModel.title)
                    .font(.title)
                
                RichTextEditor(text: $viewModel.attributedString, context: RTFContext.context)
                    .disabled(true)
                    .frame(minHeight: 300)
            }
            // TODO: Собрать свое меню
            RichTextFormatSidebar(context: RTFContext.context)
                .frame(maxWidth: 300)
        }
        .onDisappear {
            viewModel.onClose()
        }
    }
}

final class FeatureViewModel: ObservableObject {
    @Dependency(\.persistent) var store
    let feature: Feature
    
    @Published var title: String
    @Published var attributedString: NSAttributedString
    
    init(feature: Feature) {
        self.feature = feature
        title = feature.title ?? ""
        attributedString = feature.attributedText ?? .empty
    }
    
    func onClose() {
        feature.title = title
        feature.attributedText = attributedString
        feature.updatedAt = Date()
        
        store.save()
    }
}
