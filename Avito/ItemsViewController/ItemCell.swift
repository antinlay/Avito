//
//  ItemCell.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 29.11.2023.
//

import SnapKit
import UIKit

class ItemCell: UICollectionViewCell {
    // MARK: - Public
    func configure(item: ItemInfo?) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string: item!.imageURL)!)) { data, response, error in
            if let data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.titleLabel.text = item?.title
                    self.priceLabel.text = item?.price
                    self.locationLabel.text = item?.location
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = nil
                    self.titleLabel.text = item?.title
                    self.priceLabel.text = item?.price
                    self.locationLabel.text = item?.location
                }
            }
        }
        task.resume()

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
    private var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
}

// MARK: - Private Methods
private extension ItemCell {
    func initialize() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(imageView.snp.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(locationLabel.snp.top).offset(-5)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
