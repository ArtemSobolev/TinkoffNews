//
//  NewsTitlesViewModelProtocol.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation

protocol NewsTitlesViewModelProtocol: ObservableObject {
    var titles: [NewsTitle] { get }
    
    func load()
}
