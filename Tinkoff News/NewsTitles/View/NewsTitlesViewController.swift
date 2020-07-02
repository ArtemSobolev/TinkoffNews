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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tinkoff News"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(NewsTitlesCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        applySnapshot(animate: false)
        subscribeToViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.load()
    }
    
    private func createDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, newsTitle -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? NewsTitlesCell
            cell?.configure(with: newsTitle)
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
        viewModel.objectWillChange.sink { [weak self] _ in
            self?.applySnapshot()
        }
        .store(in: &subscriptions)
    }
}
