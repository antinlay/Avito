//
//  ItemViewController.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 07.12.2023.
//

import UIKit

class ItemViewController: UIViewController {
    // MARK: - Public Methods
    func configure(by selectedItem: ItemEntity?) {
        loadDetails(from: selectedItem!)
        if let imageURL = selectedItem?.imageURL {
            configureImage(for: imageURL)
        }
        self.priceLabel.text = selectedItem?.price
    }
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
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
    private var itemCollectionView: UICollectionView!
    private var loadImageTask: Task<Void, Never>?
    private var loadItemTask: Task<Void, Never>?
    
//    private var item: ItemEntity!
    
    private lazy var appService = AppService()

    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Private Methods
    private func loadDetails(from selectedItem: ItemEntity) {
        Task {
            do {
                let result = try await self.appService.getDetails(with: "/details/\(selectedItem.id).json")
                addressLabel.text = result.address
                emailLabel.text = result.email
                descriptionLabel.text = result.description
                phoneNumberLabel.text = result.phoneNumber
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Private Extension
private extension ItemViewController {
    func initialize() {
        let itemCollectionViewLayout = UICollectionViewFlowLayout()
        itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: itemCollectionViewLayout)
        itemCollectionViewLayout.scrollDirection = .vertical
        view.addSubview(itemCollectionView)
        
        itemCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        itemCollectionView.delegate = self
//        view.backgroundColor = navigationController?.navigationBar.barTintColor
        view.addSubview(imageView)
        view.addSubview(priceLabel)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(addressLabel)
        view.addSubview(emailLabel)
        view.addSubview(phoneNumberLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
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
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
    }
//    private func loadItem(id: Int?) {
//        loadItemTask?.cancel()
//        loadItemTask = Task { [weak self] in
//            self?.item = nil
//            do {
//                self?.item = try await self?.appService.getDetailsEntity(with: "/details/\(id ?? 0).json")
//            } catch {
//                print(error)
//            }
//        }
//    }
}
