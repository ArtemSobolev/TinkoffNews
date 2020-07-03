//
//  NewsDetailsViewFactory.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import UIKit

protocol NewsDetailsViewFactoryProtocol {
    func createNewsDetailsView(withSlug slug: String) -> UIViewController
}
