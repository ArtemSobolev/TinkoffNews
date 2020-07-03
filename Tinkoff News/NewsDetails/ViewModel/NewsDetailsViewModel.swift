//
//  NewsDetailsViewModel.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import Combine

class NewsDetailsViewModel: NewsDetailsViewModelProtocol {
    
    var isLoading: Bool = false {
        didSet {
            objectWillChange.send()
        }
    }
    
    var detailsText: NSAttributedString?
    
    private let slug: String
    private let interactor: NewsDetailsInteractorProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    init(slug: String, interactor: NewsDetailsInteractorProtocol) {
        self.slug = slug
        self.interactor = interactor
    }
    
    func load() {
        isLoading = true
        
        interactor
            .getDetails(withSlug: slug)
            .map { response -> NSAttributedString? in
                let text = response.response?.text ?? ""
                let data = Data(text.utf8)
                
                let output = try? NSAttributedString(data: data,
                                                     options: [.documentType: NSAttributedString.DocumentType.html,
                                                               .characterEncoding: String.Encoding.utf8.rawValue],
                                                     documentAttributes: nil)
                return output
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                
            }, receiveValue: { [weak self] text in
                self?.detailsText = text
                self?.isLoading = false
            })
            .store(in: &subscriptions)
    }
}
