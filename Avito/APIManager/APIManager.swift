//
//  APIManager.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 29.11.2023.
//

import UIKit

class APIManager {
    // MARK: - Public Methods
    func fetchItems(completion: @escaping ([ItemInfo]?) -> ()) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let itemsInfo = try? JSONDecoder().decode(ItemsInfo.self, from: data) {
                completion(itemsInfo.advertisements)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchItemDetails(id: String, completion: @escaping (ItemInfo?) -> ()) {
        let itemURLString = urlById + id + ".json"
        guard let url = URL(string: itemURLString) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let itemInfo = try? JSONDecoder().decode(ItemInfo.self, from: data) {
                completion(itemInfo)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func loadImage(completion: @escaping (UIImage?) -> ()) {
        let url = URL(string: urlString)!
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let itemInfo = try? JSONDecoder().decode(ItemInfo.self, from: data) {
                self.loadImageContent(url: itemInfo.imageURL, completion: completion)
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
    
//    func loadTitle(completion: @escaping (String?) -> ()) {
//        let url = URL(string: urlString)!
//        
//        let request = URLRequest(url: url)
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data, let itemCellInfo = try? JSONDecoder().decode(ItemCellInfo.self, from: data) {
//                for advertisement in itemCellInfo.advertisements {
//                    completion(advertisement.title)
//                }
//            } else {
//                completion(nil)
//            }
//        }
//        task.resume()
//    }
    
    // MARK: - Private Constants
    private let urlString = "https://www.avito.st/s/interns-ios/main-page.json"
    private let urlById = "https://www.avito.st/s/interns-ios/details/"
}
