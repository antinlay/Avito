//
//  ItemCell.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 29.11.2023.
//

import SnapKit
import UIKit

class ItemCell: UICollectionViewCell {
    // MARK: - Public Methods
    func configure(item: ItemEntity?) {
        if let imageURL = item?.imageURL {
            configureImage(for: imageURL)
        }
        self.titleLabel.text = item?.title
        self.titleLabel.sizeToFit()
        self.priceLabel.text = item?.price.priceFormatter("ru_RU")
        self.locationLabel.text = item?.location
        self.dateLabel.text = item?.createdDate.dateFormatter("dd MMMM, hh:mm")
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func configureImage(for url: URL) {
        loadImageTask?.cancel()

        loadImageTask = Task { [weak self] in
            self?.imageView.image = nil
            self?.activityIndicatorView.startAnimating()

            do {
                try await self?.imageView.setImage(by: url)
                if Task.isCancelled { return }
                self?.imageView.contentMode = .scaleAspectFit
            } catch {
                if Task.isCancelled { return }
                self?.imageView.image = UIImage(systemName: "exclamationmark.icloud")
                self?.imageView.contentMode = .center
            }

            self?.activityIndicatorView.stopAnimating()
        }
    }

    // MARK: - Private Properties
    private var loadImageTask: Task<Void, Never>?
    
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private let headMultiply = ((min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) / 191) / round(min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) / 191))

    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: label.font.pointSize * headMultiply * 0.9)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize * headMultiply * 0.9)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: label.font.pointSize * headMultiply * 0.7)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: label.font.pointSize * headMultiply * 0.7)
        label.textColor = .systemGray
        return label
    }()
}

// MARK: - Private Methods
private func priceFormatter(from price: String?) -> String? {
    let currencyFormatter = NumberFormatter()
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale(identifier: "ru_RU")
    currencyFormatter.maximumFractionDigits = 0
    
    guard let priceNumber = Int(price!.components(separatedBy: " ").first!) else {
        return price
    }

    return currencyFormatter.string(from: priceNumber as NSNumber)
}

// MARK: - Private Extensions
private extension ItemCell {
    func initialize() {
        let topMargin = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) * 0.006
        let leftMargin = topMargin
        let rightMargin = -leftMargin
//        let bottomMargin = screenSize.height * (-0.006)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(activityIndicatorView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topMargin)
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalToSuperview().offset(rightMargin)
            make.height.equalTo(imageView.snp.width)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(imageView.snp.center)
            make.height.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(topMargin)
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalToSuperview().offset(rightMargin)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(topMargin)
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalToSuperview().offset(rightMargin)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(topMargin)
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalToSuperview().offset(rightMargin)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(topMargin)
            make.left.equalToSuperview().offset(leftMargin)
            make.right.equalToSuperview().offset(rightMargin)
        }
    }
}
