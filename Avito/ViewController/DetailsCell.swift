//
//  DetailsCell.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 12.12.2023.
//

import UIKit
import SnapKit

class DetailsCell: UICollectionViewCell {
    // MARK: - Public Methods
    func loadDetails(selectedItem: ItemEntity?) {
        Task {
            do {
                let result = try await self.appService.getDetails(with: "/details/\(selectedItem?.id ?? 1).json")
                if let imageURL = selectedItem?.imageURL {
                    configureImage(for: imageURL)
                }
                titleLabel.text = selectedItem?.title
                priceLabel.text = selectedItem?.price.priceFormatter("ru_RU")
                locationLabel.text = selectedItem?.location
                addressLabel.text = result.address
                emailLabel.text = result.email
                descriptionLabel.text = result.description
                descriptionLabel.sizeToFit()
                phoneNumberLabel.text = result.phoneNumber
                dateLabel.text = selectedItem?.createdDate.dateFormatter("dd MMMM")
            } catch {
                print(error)
            }
        }
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
    private var loadImageTask: Task<Void, Never>?

    private lazy var appService = AppService()
    
    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
//        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0	
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .systemGray
        return label
    }()
    
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

}

private extension DetailsCell {
    func initialize() {
        contentView.addSubview(imageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(activityIndicatorView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(imageView.snp.center)
            make.height.width.equalTo(50)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
}
