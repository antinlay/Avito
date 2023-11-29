//
//  ItemsViewController.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 28.11.2023.
//

import UIKit
import SnapKit

class ItemsViewController: UIViewController, UISearchBarDelegate {
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        loadImages()
    }
    
    // MARK: - Private Properties
    private var itemsCollectionView: UICollectionView!
    private var images: [UIImage?] = []
    private let apiManager = APIManager()
}

// MARK: - Private Methods
private extension ItemsViewController {
    func initialize() {
        view.backgroundColor = .white
//        navigationItem.leftBarButtonItems = makeBarButtonItems()
        let searchBar = UISearchBar()
        searchBar.placeholder = "search"
        searchBar.delegate = self
        
        navigationItem.titleView = searchBar
        
        let itemsCollectionViewLayout = UICollectionViewFlowLayout()
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemsCollectionViewLayout)
        itemsCollectionViewLayout.scrollDirection = .vertical
        view.addSubview(itemsCollectionView)
        itemsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        itemsCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.showsVerticalScrollIndicator = false
//        tabBarItem.items = makeTabBarButtonItems()
        
    }
    
    func loadImages() {
        apiManager.loadImage { [weak self] image in
            DispatchQueue.main.async {
                self?.images.append(image)
                self?.itemsCollectionView.reloadData()
            }
        }
    }
    
//    func makeBarButtonItems() -> [UIBarButtonItem] {
//        let searchButtonItem = UIBarButtonItem()
//        searchButtonItem.image = UIImage(systemName: "magnifyingglass")
//        searchButtonItem.target = self
//        searchButtonItem.action = nil
//        
//        let favouritesButtonItem = UIBarButtonItem()
//        favouritesButtonItem.image = UIImage(systemName: "star")
//        favouritesButtonItem.target = self
//        favouritesButtonItem.action = nil
//        
//        let advertButtonItem = UIBarButtonItem()
//        advertButtonItem.image = UIImage(systemName: "note.text.badge.plus")
//        advertButtonItem.target = self
//        advertButtonItem.action = nil
//        
//        let messagesButtonItem = UIBarButtonItem()
//        messagesButtonItem.image = UIImage(systemName: "message")
//        messagesButtonItem.target = self
//        messagesButtonItem.action = nil
//        
//        let profileButtonItem = UIBarButtonItem()
//        profileButtonItem.image = UIImage(systemName: "person")
//        profileButtonItem.target = self
//        profileButtonItem.action = nil
//        
//        return [searchButtonItem, favouritesButtonItem, advertButtonItem, messagesButtonItem, profileButtonItem]
//    }
    
//    func makeTabBarButtonItems() -> [UITabBarItem] {
//        let searchButtonItem = UITabBarItem()
//        searchButtonItem.image = UIImage(systemName: "magnifyingglass")
//        
//        let favouritesButtonItem = UITabBarItem()
//        favouritesButtonItem.image = UIImage(systemName: "star")
//        
//        let advertButtonItem = UITabBarItem()
//        advertButtonItem.image = UIImage(systemName: "note.text.badge.plus")
//        
//        let messagesButtonItem = UITabBarItem()
//        messagesButtonItem.image = UIImage(systemName: "message")
//        
//        let profileButtonItem = UITabBarItem()
//        profileButtonItem.image = UIImage(systemName: "person")
//        
//        return [searchButtonItem, favouritesButtonItem, advertButtonItem, messagesButtonItem, profileButtonItem]
//    }
}

// MARK: - UICollectionDataSource
extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.configure(image: images[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 150)
    }
}
