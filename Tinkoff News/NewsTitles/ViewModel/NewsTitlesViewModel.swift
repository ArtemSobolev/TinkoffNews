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
    var isLoadingMore: Bool = false
    
    private let interactor: NewsTitlesInteractorProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private let pageSize: Int = 200
    private var pageOffset: Int { titles.count }
    private var totalResults: Int = 0
    
    init(interactor: NewsTitlesInteractorProtocol) {
        self.interactor = interactor
    }
    
    func load() {
        interactor
            .getTitles(pageSize: pageSize, pageOffset: pageOffset)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.totalResults = response.response?.total ?? 0
                
                let titles = response.response?.news?.map {
                    NewsTitle(id: $0.id ?? UUID().uuidString, title: $0.title ?? "")
                }
                .filter { !$0.title.isEmpty }
                ?? []
                self?.titles.append(contentsOf: titles)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            
            }, receiveValue: { [weak self] _ in
                self?.isLoadingMore = false
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }
    
    func loadMore() {
        guard !isLoadingMore && pageOffset < totalResults else { return }
        isLoadingMore = true
        objectWillChange.send()
        load()
    }
    
    func refresh() {
        titles.removeAll()
        load()
    }
}
