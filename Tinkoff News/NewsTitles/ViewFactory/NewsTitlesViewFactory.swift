//
//  NewsTitlesViewFactory.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit

protocol NewsTitlesViewFactoryProtocol {
    func createNewsTitlesView(coordinator: TinkoffCoordinatorProtocol) -> UIViewController
}
