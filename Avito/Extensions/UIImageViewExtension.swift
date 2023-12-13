//
//  UIImageViewExtension.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 12.12.2023.
//

import UIKit

extension UIImageView {

    private static let imageLoader = ImageLoaderService(cacheCountLimit: 500)

    @MainActor
    func setImage(by url: URL) async throws {
        let image = try await Self.imageLoader.loadImage(for: url)

        if !Task.isCancelled {
            self.image = image
            self.layer.cornerRadius = 8
            self.layer.masksToBounds = true
        }
    }

}
