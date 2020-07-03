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
    var isLoading: Bool = false
    
    private let interactor: NewsTitlesInteractorProtocol
    private let coordinator: TinkoffCoordinatorProtocol
    private var subscriptions = Set<AnyCancellable>()
    
    private let pageSize: Int = 20
    private var pageOffset: Int { titles.count }
    private var totalResults: Int = 0
    private var fullScreenLoading: Bool = true
    
    init(interactor: NewsTitlesInteractorProtocol, coordinator: TinkoffCoordinatorProtocol) {
        self.interactor = interactor
        self.coordinator = coordinator
    }
    
    func load() {
        if fullScreenLoading {
            isLoading = true
            objectWillChange.send()
        }
        
        interactor
            .getTitles(pageSize: pageSize, pageOffset: pageOffset)
            .handleEvents(receiveOutput: { [weak self] response in
                self?.totalResults = response.response?.total ?? 0
                
                let titles = response.response?.news?.map {
                    NewsTitle(id: $0.id ?? UUID().uuidString, slug: $0.slug ?? "", title: $0.title ?? "")
                }
                .filter { !$0.title.isEmpty }
                ?? []
                self?.titles.append(contentsOf: titles)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
            
            }, receiveValue: { [weak self] _ in
                self?.isLoadingMore = false
                self?.isLoading = false
                self?.objectWillChange.send()
            })
            .store(in: &subscriptions)
    }
    
    func loadMore() {
        guard !isLoadingMore && !isLoading && pageOffset < totalResults else { return }
        isLoadingMore = true
        objectWillChange.send()
        load()
    }
    
    func refresh() {
        titles.removeAll()
        fullScreenLoading = false
        load()
    }
    
    func newsSelected(withSlug slug: String) {
        coordinator.pushNewsDetails(withSlug: slug)
    }
}
