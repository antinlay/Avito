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
    private lazy var itemsInfo: [ItemEntity?] = []
    private lazy var itemCell = ItemCell()
    private lazy var itemCells: [ItemEntity?] = []
    private lazy var appService = AppService()
//    private let apiManager = APIManager()
}

// MARK: - Private Methods

// MARK: - Private Extensions
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
    }
    
    private func loadItems() {
        Task {
            do {
                itemsInfo = try await appService.getItemEntities(with: "/main-page.json")
                DispatchQueue.main.async {
                    self.itemsCollectionView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UICollectionDataSource
extension ItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ItemCell
        cell.configure(item: itemsInfo[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 190, height: 280)
    }
}

extension ItemsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = itemsInfo[indexPath.item]
        let itemViewController = ItemViewController()
        navigationController?.pushViewController(itemViewController, animated: true)
    }
}
