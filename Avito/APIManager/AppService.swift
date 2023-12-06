//
//  AppService.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import Foundation

actor AppService {
    
    // MARK: - Public Methods
    func getItemEntities(with page: String) async throws -> [ItemEntity] {
        let url = buildURL(with: page)
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let advertisements = try JSONDecoder().decode(AvitoResultsEntry.self, from: data)
        
        let entities = advertisements.advertisements.compactMap { item -> ItemEntity? in
            convert(entry: item)
        }
        
        return entities
    }
    
    // MARK: - Private Properties
    private static let baseURLString: String = "https://www.avito.st/s/interns-ios"
    
    // MARK: - Private Methods
    private func buildURL(with page: String) -> URL {
        guard let url = URL(string: Self.baseURLString + page) else {
            fatalError("Developer error can't build url for request: page=\(page)")
        }
        return url
    }
    
    private func convert(entry: AvitoResultEntry) -> ItemEntity? {
        guard let id = Int(entry.id) else {
            return nil
        }
        
        guard let imageURL = URL(string: entry.imageURL) else {
            return nil
        }
        
        let formatter = DateFormatter()
        guard let createdDate = formatter.date(from: entry.createdDate) else {
            return nil
        }
        
        return ItemEntity(id: id, title: entry.title, price: entry.price, location: entry.location, imageURL: imageURL, createdDate: createdDate)
    }
}
