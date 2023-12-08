//
//  AvitoResultEntry.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import Foundation

// MARK: - AvitoResultsEntry
struct AvitoResultsEntry: Decodable {
    let advertisements: [AvitoResultEntry]
}

// MARK: - AvitoResultEntry
struct AvitoResultEntry: Codable {
    let id, title, price, location: String
    let imageURL: String
    let createdDate: String
    let description, email, phoneNumber, address: String?

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
        case description, email
        case phoneNumber = "phone_number"
        case address
    }
}
