//
//  ScreenStateViewModel.swift
//  DocumentBuilder
//
//  Created by Михаил Серегин on 08.10.2023.
//

import Foundation
import Dependencies

final class ScreenStateViewModel: ObservableObject {
    @Dependency(\.figma) var figma
    
    @Published var state: ScreenStateModel?
    @Published var isLoading = false
    @Published var url: URL?
    @Published var data: Data?
    
    private let logger = Logger(module: "ScreenStateViewModel")
    init(state: ScreenStateModel?) {
        self.state = state
        URLCache.shared.memoryCapacity = 50_000_000 // ~50 MB memory space
        URLCache.shared.diskCapacity = 500_000_000 // ~1GB disk cache space
    }
    
    @MainActor
    func load() {
        Task {
            do {
                logger.info(message: "Start to load image from figma")
                isLoading = true
                logger.debug(message: "getImageUrl")
                let url = try await getImageUrl()
                data = try await getImageData(url: url)
                logger.info(message: "image url loaded")
                self.isLoading = false
                
            } catch {
                logger.error(message: error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    @MainActor
    private func getImageUrl() async throws -> URL {
        let figmaResponse = try await figma.getImageUrl(from: self.state?.layoutLink ?? "")
        guard let imageRef = figmaResponse.images.first?.value, let url = URL(string: imageRef) else { throw Error.badUrl }
        return url
    }
    
    private func getImageData(url: URL) async throws -> Data {
        return try await figma.loadData(url.absoluteString)
    }
}

actor FigmaRepository {
    @Dependency(\.networking) var networking
    private let logger = Logger(module: "FigmaRepository")
    private let baseUrl = "https://api.figma.com"
    private var imageURLCache = CacheData()
    private let decoder = JSONDecoder()
    
    func getImageUrl(from string: String) async throws -> FigmaResponse {
        guard let url = URL(string: string), let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { throw Error.badUrl }
        let key = String(components.path.split(separator: "/")[1])
        let nodeId = components.queryItems?.first(where: {
            $0.name == "node-id"
        })?.value ?? ""
        
        return try await getImages(key: key, node: nodeId)
    }
    
    private func getImages(key: String, node: String) async throws -> FigmaResponse {
        let apiCall = API(
            baseUrl: baseUrl,
            path: "/v1/images/\(key)",
            method: .get,
            headers: ["X-FIGMA-TOKEN":"figd_OnxDKon4jFVyrIdWFxvrMEOMkaYD_3BqL6HEvU8F"],
            query: [
                "ids": node,
                "scale": "2"
            ]
        )
        
        return try await execute(apiCall)
    }
    
    func loadData(_ url: String) async throws -> Data {
        let apiCall = API(baseUrl: url, path: "", method: .get, headers: [:], query: [:])
        return try await executeData(apiCall)
    }
    
    private func decode<T: Decodable>(data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
    
    private func execute<T:Decodable>(_ api: API) async throws -> T {
        if let cached = await imageURLCache[api] {
            return try decode(data: cached)
        } else {
            let (data, response) = try await networking.call(api: api)
            let responseCode = (response as? HTTPURLResponse)?.statusCode
            logger.info(message: "respone code: \(responseCode ?? 0)")
            logger.info(message: "respone data: \(String(data: data, encoding: .utf8) ?? "no data")")
            await imageURLCache.insert(data, for: api)
            return try decode(data: data)
        }
    }
    
    private func executeData(_ api: API) async throws -> Data {
        if let cached = await imageURLCache[api] {
            return cached
        } else {
            let (data, response) = try await networking.call(api: api)
            let responseCode = (response as? HTTPURLResponse)?.statusCode
            logger.info(message: "respone code: \(responseCode ?? 0)")
            logger.info(message: "respone data: \(String(data: data, encoding: .utf8) ?? "no data")")
            await imageURLCache.insert(data, for: api)
            return data
        }
    }
}

extension FigmaRepository: DependencyKey {
    static var liveValue: FigmaRepository = FigmaRepository()
    static var testValue: FigmaRepository = FigmaRepository()
}

extension DependencyValues {
    var figma: FigmaRepository {
        get { self[FigmaRepository.self] }
        set { self[FigmaRepository.self] = newValue }
    }
}


struct FigmaResponse: Decodable {
    let err: String?
    let images: [String:String]
}

actor CacheData {
    var cache: [API: Data] = [:]
    
    subscript(_ key: API) -> Data? {
        object(for: key)
    }
    
    func insert(_ data: Data, for api: API) {
        cache[api] = data
    }
    
    func object(for api: API) -> Data? {
        cache[api]
    }
}
