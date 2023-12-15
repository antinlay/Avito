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
    private lazy var itemEntities: [ItemEntity?] = []
    private lazy var itemCell = ItemCell()
    private lazy var appService = AppService()
}

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
        
        itemsCollectionView.register(ItemCell.self, forCellWithReuseIdentifier: "ItemCell")
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        itemsCollectionView.showsVerticalScrollIndicator = false        
    }
    
    private func loadItems() {
        Task {
            do {
                itemEntities = try await appService.getItemEntities(with: "/main-page.json")
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
        itemEntities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.configure(item: itemEntities[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsInRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 2
        let spacingBetweenItems: CGFloat = 10 // Расстояние между ячейками
        let totalSpacing = (numberOfItemsInRow - 1) * spacingBetweenItems
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsInRow
        let aspectRatio: CGFloat = 1.45 // Соотношение сторон (высота / ширина)
        let itemHeight = itemWidth * aspectRatio
        return CGSize(width: itemWidth, height: itemHeight)    }
}

extension ItemsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = itemEntities[indexPath.item]
        let detailsViewController = DetailsViewController()
        detailsViewController.configure(by: selectedItem)
        if UIDevice.current.userInterfaceIdiom == .pad {
            detailsViewController.modalPresentationStyle = .pageSheet
            present(detailsViewController, animated: true)
        } else {
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}
