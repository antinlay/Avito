//
//  ItemsInfo.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 29.11.2023.
//

import UIKit

// MARK: - ItemsInfo
struct ItemsInfo: Codable {
    var advertisements: [ItemInfo]
}

// MARK: - ItemInfo
struct ItemInfo: Codable {
    let id, title, price, location: String
    let imageURL: String
    let createdDate: String

    enum CodingKeys: String, CodingKey {
        case id, title, price, location
        case imageURL = "image_url"
        case createdDate = "created_date"
    }
}

//typealias ItemsInfo = [ItemInfo]
