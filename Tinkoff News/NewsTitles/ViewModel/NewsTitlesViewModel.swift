//
//  NewsTitlesViewModel.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import Foundation
import Combine

class NewsTitlesViewModel: NewsTitlesViewModelProtocol {
    
    var titles: [NewsTitle] = []
    
    private let interactor: NewsTitlesInteractorProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var pageOffset: Int { titles.count }
    
    init(interactor: NewsTitlesInteractorProtocol) {
        self.interactor = interactor
    }
    
    func load() {
        interactor
            .getTitles(pageSize: pageSize, pageOffset: pageOffset)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
            
            }, receiveValue: { [weak self] titles in
                self?.titles = titles
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }
}
