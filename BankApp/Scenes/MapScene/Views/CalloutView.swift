//
//  CalloutView.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import UIKit

class CalloutView: UIView {
    
    private lazy var verticalStackView: UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        return verticalStackView
    }()
    
    private lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        return nameLabel
    }()
    
    private lazy var addressLabel: UILabel = {
        var addressLabel = UILabel()
        addressLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        addressLabel.numberOfLines = 0
        return addressLabel
    }()
    
    private lazy var openingHoursLabel: UILabel = {
        var openingHoursLabel = UILabel()
        openingHoursLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        openingHoursLabel.numberOfLines = 0
        return openingHoursLabel
    }()
    
    private lazy var atmCurrencyLabel: UILabel = {
        var atmCurrencyLabel = UILabel()
        atmCurrencyLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        return atmCurrencyLabel
    }()
    
    init(name: String, address: String, openingHours: String, atmCurrency: String) {
        super.init(frame: .zero)
        self.setupStackView()
        self.setupLabel(name: name, address: address, openingHours: openingHours, atmCurrency: atmCurrency)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.addSubview(self.verticalStackView)
        [self.nameLabel, self.addressLabel, self.openingHoursLabel, self.atmCurrencyLabel].forEach { self.verticalStackView.addArrangedSubview($0) }
      
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupLabel(name: String, address: String, openingHours: String, atmCurrency: String) {
        self.nameLabel.text = name
        self.addressLabel.text = address
        self.openingHoursLabel.text = "Режим работы: " + openingHours
        self.atmCurrencyLabel.text = "Валюта: " + atmCurrency
    }
}
