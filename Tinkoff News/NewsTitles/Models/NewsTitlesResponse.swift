//
//  NewsTitlesResponse.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation

struct NewsTitlesResponse: Decodable {
    let response: Response?
}

extension NewsTitlesResponse {
    struct Response: Decodable {
        let news: [News]?
        let total: Int?
    }
}

extension NewsTitlesResponse.Response {
    struct News: Decodable {
        let title: String?
        let hidden: Bool?
    }
}
