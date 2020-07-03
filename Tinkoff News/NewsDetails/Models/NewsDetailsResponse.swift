//
//  NewsDetailsResponse.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation

struct NewsDetailsResponse: Decodable {
    let response: Response?
    
    struct Response: Decodable {
        let text: String?
    }
}
