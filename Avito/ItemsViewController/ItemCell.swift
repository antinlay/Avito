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
    func handleCellTap() {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let viewController = responder as? UIViewController {
                if let itemsViewController = viewController as? ItemsViewController {
                    let itemViewController = ItemViewController()
                    // Configure itemViewController with the necessary data
                    itemsViewController.navigationController?.pushViewController(itemViewController, animated: true)
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
        self.priceLabel.text = priceFormatter(from: item?.price)
        self.locationLabel.text = item?.location
        self.dateLabel.text = dateFormatter(from: item?.createdDate)
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Private Properties
    private var loadImageTask: Task<Void, Never>?
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray
        return label
    }()
}

// MARK: - Private Methods
private func dateFormatter(from createdDate: Date?) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
        
    return dateFormatter.string(from: createdDate!)
}

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
        
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}

extension UIImageView {

    private static let imageLoader = ImageLoaderService(cacheCountLimit: 500)

    @MainActor
    func setImage(by url: URL) async throws {
        let image = try await Self.imageLoader.loadImage(for: url)

        if !Task.isCancelled {
            self.image = image
            self.layer.cornerRadius = 8
            self.layer.masksToBounds = true
        }
    }

}
