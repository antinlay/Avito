//
//  DateFormatterCache.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 06.12.2023.
//

import Foundation

actor DateFormatterCache {
    static let shared = DateFormatterCache()
    private var formatters = [String: DateFormatter]()
    
    func formatter(with format: String) -> DateFormatter {
        if let formatter = formatters[format] {
            print("Returning chached formatter for \(format)")
            return formatter
        }
        print("Creating new formatter for \(format)")
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = format
        formatters[format] = formatter
        return formatter
    }
}
