//
//  LoadingView.swift
//  Tinkoff News
//
//  Created by Артем Соболев on 03.07.2020.
//  Copyright © 2020 Артем Соболев. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.text = "ЗАГРУЗКА"
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [spinner, label].forEach { addSubview($0) }
        
        spinner.startAnimating()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        setupSpinnerConstraints()
        setupLabelConstraints()
    }
    
    private func setupLabelConstraints() {
        label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16).isActive = true
        label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16).isActive = true
        label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 10).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    private func setupSpinnerConstraints() {
        spinner.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
        spinner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
