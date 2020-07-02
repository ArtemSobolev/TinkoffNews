//
//  NetworkClient.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import Combine
import Network

class NetworkClient: NetworkClientProtocol {
    
    private let monitor: NWPathMonitor
    private var isConnectionAvailable: Bool = true
    
    static let shared = NetworkClient()
    
    private init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnectionAvailable = path.status == .satisfied
        }
        monitor.start(queue: DispatchQueue(label: "Network connection monitoring"))
    }
    
    func getData<ResponseModel>(from urlString: String) -> AnyPublisher<ResponseModel, NetworkClientError> where ResponseModel: Decodable {
        guard let url = URL(string: urlString) else {
            return Fail(error: .invalidUrl(urlString)).eraseToAnyPublisher()
        }
        
        guard isConnectionAvailable else {
            return Fail(error: .internetConnectionDisabled).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap {
                guard let response = $0.response as? HTTPURLResponse else {
                    throw NetworkClientError.invalidResponse
                }
                
                let statusCode = response.statusCode
                guard (200..<300).contains(statusCode) else {
                    throw NetworkClientError.unsuccessStatusCode(statusCode)
                }
                
                return $0.data
            }
            .decode(type: ResponseModel.self, decoder: JSONDecoder())
            .mapError { error -> NetworkClientError in
                switch error {
                case is DecodingError:
                    return .parsingError
                case is URLError:
                    return .requestFailed
                default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
