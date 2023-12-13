//
//  PriceFormatterExtension.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 12.12.2023.
//

import Foundation

extension String {
    func priceFormatter(_ locale: String) -> String? {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: locale)
        currencyFormatter.maximumFractionDigits = 0
        
        guard let priceNumber = Int(self.components(separatedBy: " ").first!) else {
            return self
        }

        return currencyFormatter.string(from: priceNumber as NSNumber)
    }
}
