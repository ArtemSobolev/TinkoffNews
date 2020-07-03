//
//  NewsDetailsViewFactory.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import UIKit

struct NewsDetailsViewFactory {
    
    func createNewsDetailsView(withSlug slug: String) -> UIViewController {
        let interactor = NewsDetailsInteractor(networkClient: NetworkClient.shared)
        let viewModel = NewsDetailsViewModel(slug: slug, interactor: interactor)
        let view = NewsDetailsViewController(viewModel: viewModel)
        
        return view
    }
}
