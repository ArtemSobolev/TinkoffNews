//
//  NewsDetailsViewController.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit
import Combine

class NewsDetailsViewController<ViewModel: NewsDetailsViewModelProtocol>: UIViewController {
    
    let viewModel: ViewModel
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        return textView
    }()
    
    private lazy var loadingView = LoadingView(frame: view.bounds)
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(textView)
        setupConstraints()
        subscribeToViewModel()
        viewModel.load()
    }
    
    private func subscribeToViewModel() {
        viewModel.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                self.showLoadingActivity(isLoading: self.viewModel.isLoading)
                self.textView.attributedText = self.viewModel.detailsText
            }
            .store(in: &subscriptions)
    }
    
    private func showLoadingActivity(isLoading: Bool) {
        isLoading ? view.addSubview(loadingView) : loadingView.removeFromSuperview()
    }
    
    private func setupConstraints() {
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
