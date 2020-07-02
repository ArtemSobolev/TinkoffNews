//
//  NewsTitlesViewFactory.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit

struct NewsTitlesViewFactory {
    func createNewsTitlesView() -> UIViewController {
        let interactor = NewsTitlesInteractor(networkClient: NetworkClient.shared)
        let viewModel = NewsTitlesViewModel(interactor: interactor)
        let view = NewsTitlesViewController(viewModel: viewModel)
        
        return view
    }
}
