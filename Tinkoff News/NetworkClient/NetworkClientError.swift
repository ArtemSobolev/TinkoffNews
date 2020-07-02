//
//  NetworkClientError.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation

enum NetworkClientError: Error, CustomStringConvertible {
    case invalidUrl(String)
    case parsingError
    case unsuccessStatusCode(Int)
    case invalidResponse
    case internetConnectionDisabled
    case requestFailed
    case unknown
    
    var description: String {
        switch self {
        case .requestFailed:
            return "Request has failed"
        case .parsingError:
            return "Could not parse data"
        case .invalidUrl(let url):
            return "Invalid url: \(url)"
        case .unsuccessStatusCode(let code):
            return "Unsuccessfull status code: \(code)"
        case .invalidResponse:
            return "Invalid response"
        case .internetConnectionDisabled:
            return "Internet connection failed"
        case .unknown:
            return "Unknown error"
        }
    }
}
