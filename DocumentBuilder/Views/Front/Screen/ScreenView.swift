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
                    print("Добавить")
                }
            }
            TitleView
            TypeView
            SelectedState
        }
    }
    
    var TitleView: some View {
        TextField("Название экрана", text: $viewModel.item.title)
            .font(.largeTitle)
            .textFieldStyle(.plain)
    }
    
    var TypeView: some View {
        Text(viewModel.item.type.rawValue)
    }
    
    @ViewBuilder
    var SelectedState: some View {
        ScreenStateView(state: $viewModel.selectedState)
            .id(viewModel.selectedState?.state.id ?? UUID().uuidString)
    }
}

final class ScreenViewModel: ObservableObject {
    @Published var item: ScreenModel
    @Published var states: [ScreenStateModel] = []
    @Published var selectedState: ScreenStateModel?
    
    init(item: ScreenModel) {
        self.item = item
        load()
    }
    
    func load() {
        states = [
            .init(id: .init(), parentId: nil, state: "Обычный", layoutLink: "https://www.figma.com/file/sAnqEBXL9GcuMEWqxf7hiX/Concept-ISU?type=design&node-id=731-156185&mode=design&t=DHZvRcuJ1quf0buh-4"),
            .init(id: .init(), parentId: nil, state: "Пустой", layoutLink: "https://github.com/krzysztofzablocki/Swift-Macros"),
            .init(id: .init(), parentId: nil, state: "Переполненный", layoutLink: "https://github.com/krzysztofzablocki/Swift-Macros")
        ]
        self.selectedState = states.first
    }
    
    func select(_ state: ScreenStateModel) {
        self.selectedState = state
    }
}

struct ScreenStateView: View {
    @Binding var state: ScreenStateModel?
    @StateObject var WVModel: WebViewModel
    @State var isPresentSnapshotView = false
    
    init(state: Binding<ScreenStateModel?>) {
        self._state = state
        if let link = state.wrappedValue?.layoutLink {
            self._WVModel = StateObject(wrappedValue: .init(link: link))
        } else {
            self._WVModel = StateObject(wrappedValue: .init(link: ""))
        }
    }
    
    var body: some View {
        
            VStack {
//                Text(state?.state ?? "")
                TextField("Ссылка на макет", text: .init(get: {
                    state?.layoutLink ?? ""
                }, set: { newvalue in
                    state?.layoutLink = newvalue
                }), prompt: Text("Ссылка на макет"))
//                Text(state?.layoutLink ?? "")
//                Link(state?.state ?? "", destination: URL(string: state!.layoutLink)!)
                Button("сделать снимок из фигмы") {
                    isPresentSnapshotView = true
                }
                
                PasteButton(supportedContentTypes: [.image]) { providers in
                    for provider in providers {
                        provider.loadObject(ofClass: NSImage.self) { object, error in
                            if let image = object as? NSImage {
                                DispatchQueue.main.async {
                                    state?.image = image.jpegData(compressionQuality: 1)
                                }
                            }
                        }
                    }
                }
                if let imageData = state?.image, let image = NSImage(data: imageData) {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .sheet(isPresented: $isPresentSnapshotView) {
                VStack {
                    Button("take snapshot") {
                        WVModel.view?.takeSnapshot(with: .init(), completionHandler: { image, error in
                            if let image {
                                DispatchQueue.main.async {
                                    self.state?.image = image.jpegData(compressionQuality: 1)
                                    isPresentSnapshotView = false
                                }
                            }
                        })
                    }
                    WebView
                }
                .frame(width: 1194, height: 864)
            }
    }
    
    @ViewBuilder
    var WebView: some View {
        if let url = state?.layoutLink {
            SafariWebView(model: WVModel)
        }
    }
}

import WebKit
//import AppKit

struct SafariWebView: View {
    @ObservedObject var model: WebViewModel
    
    init(model: WebViewModel) {
        //Assign the url to the model and initialise the model
        self.model = model
    }
    
    var body: some View {
        //Create the WebView with the model
        SwiftUIWebView(viewModel: model)
    }
}

struct SwiftUIWebView: NSViewRepresentable {
    
    public typealias NSViewType = WKWebView
    @ObservedObject var viewModel: WebViewModel

    private let webView: WKWebView = WKWebView()
    public func makeNSView(context: NSViewRepresentableContext<SwiftUIWebView>) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator as? WKUIDelegate
        webView.load(URLRequest(url: URL(string: viewModel.link)!))
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: NSViewRepresentableContext<SwiftUIWebView>) { }

    public func makeCoordinator() -> Coordinator {
        return Coordinator(viewModel)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        private var viewModel: WebViewModel

        init(_ viewModel: WebViewModel) {
           //Initialise the WebViewModel
           self.viewModel = viewModel
        }
        
        public func webView(_: WKWebView, didFail: WKNavigation!, withError: Error) { }

        public func webView(_: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) { }

        //After the webpage is loaded, assign the data in WebViewModel class
        public func webView(_ web: WKWebView, didFinish: WKNavigation!) {
            self.viewModel.pageTitle = web.title!
            self.viewModel.link = web.url?.absoluteString ?? ""
            self.viewModel.didFinishLoading = true
            self.viewModel.view = web
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { }

        public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }

    }

}

class WebViewModel: ObservableObject {
    @Published var link: String
    @Published var didFinishLoading: Bool = false
    @Published var pageTitle: String
    var view: WKWebView?
    
    init (link: String) {
        self.link = link
        self.pageTitle = ""
    }
}
