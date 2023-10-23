//
//  ScreenStateView.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 08.10.2023.
//

import SwiftUI

struct ScreenStateView: View {
    @ObservedObject var viewModel: ScreenStateViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(viewModel.state?.layoutLink ?? "")
//            Button("сделать снимок из фигмы") {
//                viewModel.load()
//            }
//            
//            PasteButton(supportedContentTypes: [.image]) { providers in
//                for provider in providers {
//                    provider.loadObject(ofClass: NSImage.self) { object, error in
//                        if let image = object as? NSImage {
//                            DispatchQueue.main.async {
//                                viewModel.state?.image = image.jpegData(compressionQuality: 1)
//                            }
//                        }
//                    }
//                }
//            }
            
            image
        }
        .onAppear {
            Task {
                viewModel.load()
            }
        }
    }
    
    @ViewBuilder
    var image: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.linear)
        } else {
            if let data = viewModel.data, let image = NSImage(data: data) {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 500)
            }
        }
    }
}

