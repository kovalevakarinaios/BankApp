//
//  ListViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 2.06.24.
//

import UIKit

class ListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView ()
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    private func setupCollectionView() {
        self.view.addSubview(self.collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
