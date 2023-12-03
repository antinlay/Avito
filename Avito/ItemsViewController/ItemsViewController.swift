//
//  ItemsViewController.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 28.11.2023.
//

import UIKit
import SnapKit

class ItemsViewController: UIViewController {
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        loadItems()
    }
    
    // MARK: - Private Properties
    private var itemsCollectionView: UICollectionView!
    private var itemsInfo: [ItemInfo?] = []
    private var itemCell = ItemCell()
    private var itemCells: [ItemCell?] = []
    private let apiManager = APIManager()
}

// MARK: - Private Methods
private extension ItemsViewController {
    func initialize() {
        
        let itemsCollectionViewLayout = UICollectionViewFlowLayout()
        itemsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemsCollectionViewLayout)
        itemsCollectionViewLayout.scrollDirection = .vertical
        view.addSubview(itemsCollectionView)
        itemsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        itemsCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: "cell")
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.showsVerticalScrollIndicator = false
//        tabBarItem.items = makeTabBarButtonItems()
        
    }
    
    private func loadItems() {
        apiManager.fetchItems { [weak self] items in
            DispatchQueue.main.async {
                self?.itemsInfo = items!
                self?.itemsCollectionView.reloadData()
            }
        }
    }
    
//    private func loadItems() {
////        var itemsData: [ItemInfo?] = []
//        apiManager.fetchItems { [weak self] items in
//            let dispatchGroup = DispatchGroup()
//            
////            DispatchQueue.main.async {
//                print(items?.first?.title)
//                items?.forEach({ item in
//                    dispatchGroup.enter()
//                    self?.itemsInfo.append(item)
//                    dispatchGroup.leave()
//                    
//                })
////                self?.itemCell.configure(item: item)
////                self?.itemsInfo.append(contentsOf: item!)
//            dispatchGroup.notify(queue: .main) {
////                self?.itemsInfo = itemsData
//                self?.itemsCollectionView.reloadData()
//            }
////                self?.itemsCollectionView.reloadData()
////            }
//        }
//    }
}

// MARK: - UICollectionDataSource
extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("ItemsInfo: \(itemsInfo.count) ItemCells: \(itemCells.count)")
        return itemsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
        cell.configure(item: itemsInfo[indexPath.item])
        print(cell.titleLabel)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 150, height: 300)
    }
}
