//
//  ImageCell.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 29.11.2023.
//

import SnapKit
import UIKit

class ImageCell: UICollectionViewCell {
    // MARK: - Public
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Properties
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}

// MARK: - Private Methods
private extension ImageCell {
    func initialize() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}
