//
//  NewsDetailsInteractorProtocol.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Combine

protocol NewsDetailsInteractorProtocol {
    func getDetails(withSlug slug: String) -> AnyPublisher<NewsDetailsResponse, Error>
}
