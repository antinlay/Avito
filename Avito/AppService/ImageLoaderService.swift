//
//  ImageLoaderService.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import Foundation
import UIKit

actor ImageLoaderService {
    // MARK: - Public Methods
    func loadImage(for url: URL) async throws -> UIImage {
        if let image = lookupCache(for: url) {
            return image
        }
        
        let image = try await doLoadImage(for: url)
        
        updateCache(image: image, and: url)
        
        return lookupCache(for: url) ?? image
    }
    
    // MARK: - Private Properties
    private var cache = NSCache<NSURL, UIImage>()
    
    // MARK: - Init
    init(cacheCountLimit: Int) {
        cache.countLimit = cacheCountLimit
    }
    
    // MARK: - Private Methods
    private func doLoadImage(for url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)
        
        // эффект плохого интернета
//        try await Task.sleep(nanoseconds: 1000 * 1000 * 1000 * .random(in: 0...2))
//        if .random() {
//            throw POSIXError(.E2BIG)
//        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeContentData)
        }
        
        return image
    }
    
    private func lookupCache(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    private func updateCache(image: UIImage, and url: URL) {
        if cache.object(forKey: url as NSURL) == nil {
            cache.setObject(image, forKey: url as NSURL)
        }
    }
}
