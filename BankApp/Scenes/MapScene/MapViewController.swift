//
//  ViewController.swift
//  BankApp
//
//  Created by Karina Kovaleva on 27.05.24.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    private lazy var map: MKMapView = {
        var map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
    }
    
    private func setupMap() {
        self.view.addSubview(self.map)
        
        NSLayoutConstraint.activate([
            self.map.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.map.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.map.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.map.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}
