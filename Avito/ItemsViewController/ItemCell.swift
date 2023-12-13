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
    func handleCellTap() {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                if let itemsViewController = viewController as? ItemsViewController {
                    let detailsViewController = DetailsViewController()
                    // Configure itemViewController with the necessary data
                    itemsViewController.navigationController?.pushViewController(detailsViewController, animated: true)
                    break
                }
            }
        }
    }
    
    func configure(item: ItemEntity?) {
        if let imageURL = item?.imageURL {
            configureImage(for: imageURL)
        }
        self.titleLabel.text = item?.title
        self.priceLabel.text = item?.price.priceFormatter("ru_RU")
        self.locationLabel.text = item?.location
        self.dateLabel.text = item?.createdDate.dateFormatter("dd.MM.yyyy")
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
    
    // MARK: - Prepare For Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Сбросить содержимое ячейки перед повторным использованием
        imageView.image = nil
    }

    // MARK: - Private Properties
    private var loadImageTask: Task<Void, Never>?
    
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
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
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(activityIndicatorView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalTo(imageView.snp.width)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(imageView.snp.center)
            make.height.width.equalTo(20)
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
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
