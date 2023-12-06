//
//  ImageLoader.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 04.12.2023.
//

import UIKit

actor ImageLoader {
    private var images: [URLRequest : LoaderStatus] = [ : ]
    
    func fetch(_ url: URL) async throws -> UIImage {
        let request = URLRequest(url: url)
        return try await fetch(request)
    }
    
    private func fetch(_ urlRequest: URLRequest) async throws -> UIImage {
        if let status = images[urlRequest] {
            switch status {
            case .fetched(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        if let image = try self.imageFromFileSystem(for: urlRequest) {
            images[urlRequest] = .fetched(image)
            return image
        }
        
        let task: Task<UIImage, Error> = Task {
            let (imageData, _) = try await URLSession.shared.data(for: urlRequest)
            let image = UIImage(data: imageData)!
            try self.persistImage(image, for: urlRequest)
            return image
        }
        
        images[urlRequest] = .inProgress(task)
        let image = try await task.value
        images[urlRequest] = .fetched(image)
        return image
    }
    
    private func persistImage(_ image: UIImage, for urlRequest: URLRequest) throws {
        guard let url = fileName(for: urlRequest), let data = image.jpegData(compressionQuality: 0.8) else {
            assertionFailure("Unable to generate a local path for \(urlRequest)")
            return
        }
        
        try data.write(to: url)
    }
    
    private func imageFromFileSystem(for urlRequest: URLRequest) throws -> UIImage? {
        guard let url = fileName(for: urlRequest) else {
            assertionFailure("Unable to generate a local path for \(urlRequest)")
            return nil
        }
        
        let data = try Data(contentsOf: url)
        return UIImage(data: data)
    }
    
    private func fileName(for urlRequest: URLRequest) -> URL? {
        guard let fileName = urlRequest.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed), let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .allDomainsMask).first else {
            return nil
        }
        print(applicationSupport.appendingPathComponent(fileName))
        return applicationSupport.appendingPathComponent(fileName)
    }
    
//    private func fileName(for urlRequest: URLRequest) -> URL? {
//        guard let url = urlRequest.url,
//              let fileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
//              let applicationSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
//            return nil
//        }
//        
//        let fileURL = applicationSupport.appendingPathComponent(fileName)
//        print(fileURL)
//        return fileURL
//    }
    
    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }
}
