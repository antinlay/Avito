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
    
    static func == (lhs: ItemEntity, rhs: ItemEntity) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
