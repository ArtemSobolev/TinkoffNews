//
//  NewsDetailsInteractor.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Combine

class NewsDetailsInteractor: NewsDetailsInteractorProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getDetails(withSlug slug: String) -> AnyPublisher<NewsDetailsResponse, Error> {
        let path = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticle?urlSlug=\(slug)"
        return networkClient.getData(from: path, responseModelType: NewsDetailsResponse.self)
    }
}
