//
//  ItemEntity.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import UIKit

struct ItemEntity: Hashable {
    let id: Int
    let title: String
    let price: String
    let location: String
    let imageURL: URL
    let createdDate: Date
    
    let description: String?
    let email: String?
    let phoneNumber: String?
    let address: String?
    
    static func == (lhs: ItemEntity, rhs: ItemEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(id: Int, title: String, price: String, location: String, imageURL: URL, createdDate: Date) {
        self.id = id
        self.title = title
        self.price = price
        self.location = location
        self.imageURL = imageURL
        self.createdDate = createdDate
        self.description = nil
        self.email = nil
        self.phoneNumber = nil
        self.address = nil
    }
}
