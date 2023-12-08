//
//  ItemViewController.swift
//  Avito
//
//  Created by Ляхевич Александр Олегович on 07.12.2023.
//

import UIKit

class ItemViewController: UIViewController {
    // MARK: - Public Methods
    func configure(id: Int) {
        
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
    private var loadImageTask: Task<Void, Never>?
    
    private var item: ItemEntity!
    
    private lazy var appService = AppService()

    private lazy var activityIndicatorView = UIActivityIndicatorView()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
}

// MARK: - Private Extension
private extension ItemViewController {
    func initialize() {
        view.addSubview(imageView)
        view.addSubview(priceLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    private func loadItem(id: Int) {
        Task {
            do {
                item = try await appService.getDetailsEntity(with: "/details/\(id)")
            } catch {
                print(error)
            }
        }
    }
}
