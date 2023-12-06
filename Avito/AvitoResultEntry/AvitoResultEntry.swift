//
//  AvitoResultEntry.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import Foundation

// MARK: - AvitoResultEntry
struct AvitoResultEntry: Decodable {
    let id, title, price, location: String
    let imageURL: String
    let createdDate: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
    }
}

struct AvitoResultsEntry: Decodable {
    let advertisements: [AvitoResultEntry]
}

// MARK: - AvitoDetailsEntry
struct AvitoDetailsEntry: Codable {
    let id, title, price, location: String
    let imageURL: String
    let createdDate, description, email, phoneNumber: String
    let address: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
        case description, email
        case phoneNumber = "phone_number"
        case address
    }
}
