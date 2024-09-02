//
//  HeaderView.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.08.24.
//

import UIKit

class HeaderView: UICollectionReusableView {
    
    static let identifier = "HeaderView"
    
    private lazy var cityLabel: UILabel = {
        var cityLabel = UILabel()
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        cityLabel.textAlignment = .left
        cityLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        return cityLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLabel()
        self.setupBackground()
    }
    
    private func setupBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [
                 UIColor(red: 0.5, green: 0.8, blue: 0.5, alpha: 1.0).cgColor,
                 UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0).cgColor
             ]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupLabel() {
        self.addSubview(self.cityLabel)
        
        NSLayoutConstraint.activate([
            self.cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            self.cityLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            self.cityLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5),
            self.cityLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5)
        ])
    }
    
    func setText(city: String) {
        self.cityLabel.text = city
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
