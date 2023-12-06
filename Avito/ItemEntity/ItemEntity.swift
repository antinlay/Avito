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
    
    static func == (lhs: ItemEntity, rhs: ItemEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct ItemDetailEntity {
    let id: Int
    let title: String
    let price: String
    let location: String
    let image: UIImage
    let createdDate: Date
    
    let description: String
    let email: String
    let phoneNumber: String
    let address: String
    
}
