//
//  Coordinator.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    func start()
}

protocol TinkoffCoordinatorProtocol: CoordinatorProtocol {
    func pushNewsDetails(withSlug slug: String)
}

protocol TinkoffCoordinatorFactoryProtocol {
    func createTinkoffCoordinator() -> TinkoffCoordinatorProtocol
}

class TinkoffCoordinator: TinkoffCoordinatorProtocol {
    
    private let newsTitlesViewFactory: NewsTitlesViewFactoryProtocol
    private let newsDetailsViewFactory: NewsDetailsViewFactoryProtocol
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         newsTitlesViewFactory: NewsTitlesViewFactoryProtocol,
         newsDetailsViewFactory: NewsDetailsViewFactoryProtocol) {
        
        self.navigationController = navigationController
        self.newsTitlesViewFactory = newsTitlesViewFactory
        self.newsDetailsViewFactory = newsDetailsViewFactory
    }
    
    func start() {
        let view = newsTitlesViewFactory.createNewsTitlesView(coordinator: self)
        navigationController.pushViewController(view, animated: false)
    }
    
    func pushNewsDetails(withSlug slug: String) {
        let view = newsDetailsViewFactory.createNewsDetailsView(withSlug: slug)
        navigationController.pushViewController(view, animated: true)
    }
}

