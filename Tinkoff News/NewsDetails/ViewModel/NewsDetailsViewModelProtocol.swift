//
//  NewsDetailsViewModelProtocol.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation

protocol NewsDetailsViewModelProtocol: ObservableObject {
    var isLoading: Bool { get }
    var detailsText: NSAttributedString? { get }
    
    func load()
}
