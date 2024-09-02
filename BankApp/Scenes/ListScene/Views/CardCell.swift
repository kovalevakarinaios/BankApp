//
//  CardCell.swift
//  BankApp
//
//  Created by Karina Kovaleva on 3.06.24.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    static let identifier = "CardCell"
    
    private lazy var verticalStackView: UIStackView = {
        var verticalStackView = UIStackView()
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.distribution = .fillEqually
        return verticalStackView
    }()
    
    private lazy var nameLabel: UILabel = {
        var nameLabel = UILabel()
        nameLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.textColor = .label
        return nameLabel
    }()
    
    private lazy var addressLabel: UILabel = {
        var addressLabel = UILabel()
        addressLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        addressLabel.numberOfLines = 0
        addressLabel.lineBreakMode = .byWordWrapping
        addressLabel.textColor = .secondaryLabel
        return addressLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        self.contentView.backgroundColor = .systemGray5
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.contentView.layer.shadowRadius = 4
        
        [self.nameLabel, self.addressLabel].forEach { self.verticalStackView.addArrangedSubview($0) }
        
        self.addSubview(self.verticalStackView)
        
        NSLayoutConstraint.activate([
            self.verticalStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.verticalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.verticalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.verticalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    func configureCell(name: String, address: String) {
        self.nameLabel.text = name
        self.addressLabel.text = address
    }
}
