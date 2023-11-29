//
//  APIManager.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 29.11.2023.
//

import UIKit

class APIManager {
    func loadImage(completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let itemCellInfo = try? JSONDecoder().decode(ItemCellInfo.self, from: data) {
                for advertisement in itemCellInfo.advertisements {
                    self.loadImageContent(url: advertisement.imageURL, completion: completion)
//                    let image = UIIma
                    print(advertisement.imageURL)
                }
            }
        }
        task.resume()
    }
    
    func loadImageContent(url: String, completion: @escaping (UIImage?) -> ()) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: url)!)) { data, response, error in
            if let data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    // MARK: - Private Constants
    private let urlString = "https://www.avito.st/s/interns-ios/main-page.json"
}
