//
//  Tinkoff.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit

class Tinkoff {
    
    private let navigationController: UINavigationController
    private let networkClient: NetworkClientProtocol
    
    init(window: UIWindow) {
        navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        networkClient = NetworkClient.shared
        window.rootViewController = navigationController
    }
}

extension Tinkoff: NewsDetailsViewFactoryProtocol {
    func createNewsDetailsView(withSlug slug: String) -> UIViewController {
        let interactor = NewsDetailsInteractor(networkClient: networkClient)
        let viewModel = NewsDetailsViewModel(slug: slug, interactor: interactor)
        let view = NewsDetailsViewController(viewModel: viewModel)
        view.title = "Details"
        view.navigationItem.largeTitleDisplayMode = .never
        
        return view
    }
}

extension Tinkoff: NewsTitlesViewFactoryProtocol {
    func createNewsTitlesView(coordinator: TinkoffCoordinatorProtocol) -> UIViewController {
        let interactor = NewsTitlesInteractor(networkClient: networkClient)
        let viewModel = NewsTitlesViewModel(interactor: interactor, coordinator: coordinator)
        let view = NewsTitlesViewController(viewModel: viewModel)
        view.title = "Tinkoff News"
        
        return view
    }
}

extension Tinkoff: TinkoffCoordinatorFactoryProtocol {
    func createTinkoffCoordinator() -> TinkoffCoordinatorProtocol {
        TinkoffCoordinator(navigationController: navigationController,
                           newsTitlesViewFactory: self,
                           newsDetailsViewFactory: self)
    }
}
