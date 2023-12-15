//
//  DetailsViewController.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 12.12.2023.
//

import UIKit
import SnapKit

class DetailsViewController: UIViewController {
    // MARK: - Public Methods
    func configure(by selectedItem: ItemEntity?) {
        self.selectedItem = selectedItem
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    // MARK: - Privte Properties
    private var detailsCollectionView: UICollectionView!
    private lazy var detailsCell = DetailsCell()
    private var selectedItem: ItemEntity!
    private lazy var appService = AppService()
}

// MARK: - Private Extensions
private extension DetailsViewController {
    func initialize() {
        let detailsCollectionViewLayout = UICollectionViewFlowLayout()
        detailsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: detailsCollectionViewLayout)
        detailsCollectionViewLayout.scrollDirection = .vertical
        view.addSubview(detailsCollectionView)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            detailsCollectionView.inputViewController?.isModalInPresentation = false
        }
        
        detailsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        detailsCollectionView.register(DetailsCell.self, forCellWithReuseIdentifier: "DetailsCell")
        detailsCollectionView.dataSource = self
        detailsCollectionView.delegate = self
        detailsCollectionView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UICollectionDelegate
extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        detailsCollectionView.bounds.size
    }
}

// MARK: - UICollectionDataSource
extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: "DetailsCell", for: indexPath) as! DetailsCell
        DispatchQueue.main.async {
            cell.loadDetails(selectedItem: self.selectedItem)
        }
        return cell
    }
}
