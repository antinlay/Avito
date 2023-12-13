//
//  AppService.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import Foundation

actor AppService {
    
    // MARK: - Public Methods
    func getDetails(with page: String) async throws -> AvitoResultEntry {
        let data = try await getData(with: page)
        
        let item = try JSONDecoder().decode(AvitoResultEntry.self, from: data)
        
        return item
    }
    
    func getItemEntities(with page: String) async throws -> [ItemEntity] {
        let data = try await getData(with: page)
        
        let advertisements = try JSONDecoder().decode(AvitoResultsEntry.self, from: data)
        
        let entities = advertisements.advertisements.compactMap { item -> ItemEntity? in
            return convert(entry: item, dateFormat: "yyyy-MM-dd")
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
    
    private func getDataResponse(for urlRequest: URLRequest) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
    
    private func getData(with page: String) async throws -> Data {
        let url = buildURL(with: page)
        let urlRequest = URLRequest(url: url)
        let data = try await getDataResponse(for: urlRequest)
        
        return data
    }
    
    private func convert(entry: AvitoResultEntry, dateFormat: String) -> ItemEntity? {
        guard let id = Int(entry.id) else {
            fatalError("Developer error can't build id for entry: id=\(entry.id)")
        }
        
        guard let imageURL = URL(string: entry.imageURL) else {
            fatalError("Developer error can't build imageURL for request: imageURL=\(entry.imageURL)")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        
        guard let createdDate = formatter.date(from: entry.createdDate) else {
            fatalError("Developer error can't build createdDate for request: createdDate=\(entry.createdDate)")
        }
        
        return ItemEntity(id: id, title: entry.title, price: entry.price, location: entry.location, imageURL: imageURL, createdDate: createdDate)
    }
}
