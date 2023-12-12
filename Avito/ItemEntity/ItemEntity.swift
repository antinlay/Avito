//
//  ItemEntity.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import UIKit

struct ItemEntity: Hashable {
    var id: Int
    var title: String
    var price: String
    var location: String
    var imageURL: URL
    var createdDate: Date
    
    var description: String?
    var email: String?
    var phoneNumber: String?
    var address: String?
    
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
