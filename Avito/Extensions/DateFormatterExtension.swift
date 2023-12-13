//
//  DateFormatterExtension.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 12.12.2023.
//

import Foundation

extension Date {
    func dateFormatter(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
            
        return dateFormatter.string(from: self)
    }
}
