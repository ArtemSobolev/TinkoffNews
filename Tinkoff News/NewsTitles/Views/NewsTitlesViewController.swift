//
//  NewsTitlesViewController.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 02.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit
import Combine

class NewsTitlesViewController<ViewModel: NewsTitlesViewModelProtocol>: UITableViewController {
    
    typealias DataSource = UITableViewDiffableDataSource<NewsTitlesSection, NewsTitle>
    typealias Snapshot = NSDiffableDataSourceSnapshot<NewsTitlesSection, NewsTitle>
    
    let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataSource: DataSource = createDataSource()
    private var subscriptions = Set<AnyCancellable>()
    private let cellId = "NewsTitlesCell"
    private var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tinkoff News"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupTableView()
        setupRefreshControl()
        applySnapshot(animate: false)
        subscribeToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingView = LoadingView(frame: view.bounds)
        viewModel.load()
    }
    
    private func createDataSource() -> DataSource {
        DataSource(tableView: tableView) { [weak self] tableView, indexPath, item -> UITableViewCell? in
            guard let self = self else { return nil }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId,
                                                     for: indexPath) as? NewsTitlesCell
            cell?.configure(with: item)
            return cell
        }
    }
    
    private func applySnapshot(animate: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.titles)
        dataSource.apply(snapshot, animatingDifferences: animate)
    }
    
    private func subscribeToViewModel() {
        viewModel.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                
                guard let self = self else { return }
                
                self.showLoadingActivity(isLoading: self.viewModel.isLoading)
                
                if self.refreshControl?.isRefreshing == true {
                    self.refreshControl?.endRefreshing()
                }
                
                if !self.viewModel.isLoadingMore {
                    self.applySnapshot()
                }
                
                self.tableView.tableFooterView?.isHidden = !self.viewModel.isLoadingMore
            }
            .store(in: &subscriptions)
    }
    
    private func setupTableView() {
        tableView.register(NewsTitlesCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 60)
        spinner.startAnimating()
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = true
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        viewModel.refresh()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomY = scrollView.contentOffset.y + scrollView.frame.height
        let contentHeight = scrollView.contentSize.height

        if bottomY * 1.5 >= contentHeight && !viewModel.titles.isEmpty {
            viewModel.loadMore()
        }
    }
    
    private func showLoadingActivity(isLoading: Bool) {
        isLoading ? tableView.addSubview(loadingView) : loadingView.removeFromSuperview()
    }
}
