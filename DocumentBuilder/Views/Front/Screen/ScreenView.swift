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
        HStack {
            VStack {
                TitleView
                LinkView
            }
            .frame(maxWidth: 300)
            imageView
        }
    }
    
    var TitleView: some View {
        TextField("Название экрана", text: $viewModel.state.state)
    }
    
    var LinkView: some View {
        TextField("Ссылка на макет", text: $viewModel.state.layoutLink)
    }
    
    @ViewBuilder
    var imageView: some View {
        if let imageData = viewModel.state.image, let image = NSImage(data: imageData) {
            Image(nsImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            PasteButton(supportedContentTypes: [.image]) { providers in
                for provider in providers {
                    provider.loadObject(ofClass: NSImage.self, completionHandler: { object, error in
                        if let image = object as? NSImage {
                            DispatchQueue.main.async {
                                self.viewModel.state.image = image.jpegData(compressionQuality: 1)
                                self.viewModel.objectWillChange.send()
                            }
                        }
                    })
                }
            }
            .labelStyle(.titleOnly)
        }
    }
}

final class ScreenViewModel: ObservableObject {
    @Published var state: ScreenStateModel
    
    init(state: ScreenStateModel) {
        self.state = state
    }
}
