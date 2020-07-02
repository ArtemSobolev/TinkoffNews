//
//  NetworkClientProtocol.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import Combine

protocol NetworkClientProtocol {
    func getData<ResponseModel: Decodable>(from urlString: String,
                                           responseModelType: ResponseModel.Type)
        -> AnyPublisher<ResponseModel, NetworkClientError>
}
