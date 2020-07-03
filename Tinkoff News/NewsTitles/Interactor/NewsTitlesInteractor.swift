//
//  NewsTitlesInteractor.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import Combine

class NewsTitlesInteractor: NewsTitlesInteractorProtocol {
    
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func getTitles(pageSize: Int, pageOffset: Int) -> AnyPublisher<NewsTitlesResponse, Error> {
        let path = "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles?pageSize=\(pageSize)&pageOffset=\(pageOffset)"
        return networkClient
            .getData(from: path, responseModelType: NewsTitlesResponse.self)
            .eraseToAnyPublisher()
    }
}
